using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AccountImporter : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "",user="";
    public int uid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"]!=null)
        { roleType = Session["roleType"].ToString(); }
        if (Session["uid"] != null && Session["name"] != null)
        {
            uid = int.Parse(Session["uid"].ToString());
            user = Session["name"].ToString();
        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int id= int.Parse(Request.QueryString["id"].ToString());
                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delinv"])))
                {
                    int x = int.Parse(Request.QueryString["delinv"].ToString());
                    importer_account it = db.importer_account.FirstOrDefault(a => a.id == x);
                    db.importer_account.Remove(it);
                    db.SaveChanges();
                    Response.Redirect("AccountImporter.aspx?id=" + id);
                }
                else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["print"])))
                {
                    int x = int.Parse(Request.QueryString["print"].ToString());
                    importer_account it = db.importer_account.FirstOrDefault(a => a.id == x);
                    title.SelectedValue = it.title;
                    if (title.SelectedValue == "سداد")
                    {

                        value.Text = it.mdeen.ToString();
                    }
                    else if (title.SelectedValue == "فاتوره")
                    {

                        value.Text = it.daan.ToString();
                    }
                    else
                    {

                        value.Text = it.mdeen.ToString();
                    }
                  
                    /////////////////////////////////////////////////////////////
                    string q = @"select * from [dbo].[importer_account] impc join [dbo].[importer] imp on imp.id=impc.importer_id where impc.id="+x+" and imp.roleType='"+roleType+"'";
                    string cr = "importeraznR.rpt";
                    Session["query"] = q;
                    Session["value"] = value.Text.ToString();
                    Session["cr"] = cr;
                    Response.Redirect("report.aspx");
                }
                else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["impprint"])))
                {
                    int x = int.Parse(Request.QueryString["impprint"].ToString());


                    string q = @"select *, it.total as tot ,it.total2 as tot2 from import inv join import_items it on inv.id= it.imp_id join importer imp on imp.id=inv.importer_id
where it.imp_id=" + x + " ";
                    string cr = "ImportinvoiceR.rpt";
                    Session["query"] = q;
                    Session["cr"] = cr;
                    Response.Redirect("report.aspx");
                }
                else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["impdelete"])))
                {
                    int idd = int.Parse(Request.QueryString["id"].ToString());
                   string x = Request.QueryString["impdelete"].ToString();
                    var f = db.savee.Where(a => a.item_id == x).FirstOrDefault();
                    int d = int.Parse(x);
                   var importeracc = (from g in db.importer_account where g.id == d select g).FirstOrDefault();
                    if (f != null)
                    {  db.savee.Remove(f);
                        db.SaveChanges();
                    }

                    db.importer_account.Remove(importeracc);
                    db.SaveChanges();

                    Response.Redirect("AccountImporter.aspx?id=" + idd);


                }
            }
        }
    }

    protected void btnadd_Click(object sender, EventArgs e)
    {
        int id = 0;
        string name = "";
        string typeName = "";
        float mdeenval = 0, daanval = 0;
        if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
        {
             id = int.Parse(Request.QueryString["id"].ToString());
            importer c = db.importer.FirstOrDefault(a => a.id == id);
            name = c.name.ToString();
        }
       
            if (title.SelectedValue == "سداد")
            {
                typeName = "سداد";
                mdeenval = float.Parse(value.Text);
            }
            else if (title.SelectedValue == "فاتوره")
            {
                typeName = "فاتوره";
                daanval = float.Parse(value.Text);
            }
            else
            {
                typeName = "مرتجع";
                mdeenval = float.Parse(value.Text);
            }
            importer_account cd = new importer_account
            {
                user_id = uid,
                user_name = user,
                title = typeName,
                importer_id = id,
                date = DateTime.Now,
                mdeen = mdeenval,
                daan = daanval,
                importer_name = name
            };
            db.importer_account.Add(cd);
            db.SaveChanges();
            if (title.SelectedValue == "سداد")
            {
                savee bb = new savee
                {
                    date = DateTime.Now,
                    item_id = cd.id.ToString(),
                    daan = float.Parse(value.Text),
                    mdeen=0,
                    title = "سداد مبلغ من المورد" + cd.importer_name,
                    user_id = uid,
                    user_name = user,
                    roleType=roleType
                };
                db.savee.Add(bb);
                db.SaveChanges();
            }
          Response.Redirect("AccountImporter.aspx?id=" + id);

    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList1.SelectedValue == "2")
        {
            bankddl.Visible = true;
            var b = db.bank.Where(a => a.roleType == roleType).ToList();
            bankddl.DataSource = b;
            bankddl.DataValueField = "id";
            bankddl.DataTextField = "BankName";
            bankddl.DataBind();
        }
        else bankddl.Visible = false;
    }
}