using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Importers : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"]!=null)
        {
            roleType = Session["roleType"].ToString();
        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int x = int.Parse(Request.QueryString["id"].ToString());
                importer f = db.importer.FirstOrDefault(a => a.id == x);
                db.importer.Remove(f);
                db.SaveChanges();
                Response.Redirect("Importers.aspx");

            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["editid"])))
            {
                int x = int.Parse(Request.QueryString["editid"].ToString());
                importer f = db.importer.FirstOrDefault(a => a.id == x);
                client.Text = f.name.ToString();
                phone.Text = f.phone.ToString();
                address.Text = f.address.ToString();
                add.Text = "تعديل";


            }
        }
    }

    protected void add_Click(object sender, EventArgs e)
    { if (add.Text == "تعديل")
            {
                int t = int.Parse(Request.QueryString["editid"].ToString());
                importer f = db.importer.FirstOrDefault(a => a.id == t);
                f.name = client.Text;
                f.address = address.Text;
                f.phone = phone.Text;
               
                db.SaveChanges();
                Response.Redirect("Importers.aspx");

            }
            else { importer c = new importer
                {
                    name = client.Text,
                    phone = phone.Text,
                    address = address.Text,
                    balance = 0,
                    roleType=roleType
                };
                Mapper.addimporter(c);
                Response.Redirect("Importers.aspx");
            }
    
    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }
}