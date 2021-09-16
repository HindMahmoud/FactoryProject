using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class AccountCustomer : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "", user = "";
    public int uid = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["uid"] != null && Session["name"] != null)
        {
            uid = int.Parse(Session["uid"].ToString());
            user = Session["name"].ToString();
        }
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int id = int.Parse(Request.QueryString["id"].ToString());
                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delinv"])))
                {
                    int x = int.Parse(Request.QueryString["delinv"].ToString());
                    customer_account it = db.customer_account.FirstOrDefault(a => a.id == x);
                    db.customer_account.Remove(it);
                    db.SaveChanges();
                    Response.Redirect("AccountCustomer.aspx?id=" + id);
                }
                else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["print"])))
                {
                    int x = int.Parse(Request.QueryString["print"].ToString());
                    customer_account it = db.customer_account.FirstOrDefault(a => a.id == x);
                   
                    /////////////////////////////////////////////////////////////
                    string q = @"select * from [dbo].[customer_account] impc join [dbo].[customer] imp on imp.id=impc.customer_id where impc.id=" + x + "";
                    string cr = "customeraznR.rpt";
                    Session["query"] = q;
                    Session["value"] = value.ToString();
                    Session["cr"] = cr;
                    Response.Redirect("report.aspx");
                }
              else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["invdelete"])))
                {
                    int idd = int.Parse(Request.QueryString["id"].ToString());

                    int x = int.Parse(Request.QueryString["invdelete"].ToString());
                    var f = db.invoice_items.Where(a => a.inv_id == x).Distinct().ToList();
                    var ff = db.invoice.Where(a => a.id == x).FirstOrDefault();

                    foreach (var item in f)
                    {
                        stock pro = db.stock.FirstOrDefault(a => a.code == item.prod_code);
                        pro.quantity = pro.quantity + item.quantity;
                        db.SaveChanges();
                      

                    }

                    db.invoice_items.RemoveRange(f);
                    db.SaveChanges();
                      var importeracc = (from g in db.customer_account where g.inv_id == x select g).FirstOrDefault();
                    if (importeracc != null)
                    {
                        db.customer_account.Remove(importeracc);
                        db.SaveChanges();
                    }
                    db.invoice.Remove(ff);
                    db.SaveChanges();
                    Response.Redirect("AccountCustomer.aspx?id=" + idd);


                }
                else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["invprint"])))
                {
                    int x = int.Parse(Request.QueryString["invprint"].ToString());

                    string q = @"select *,[casherName], it.total as tot , it.[Nettotal] as tot2 from invoice inv join invoice_items it
on inv.id= it.inv_id join customer imp on imp.id=inv.customer_id  
where inv.id=" + x + "";
                    string cr = "SaleInvoiceR.rpt";
                    Session["query"] = q;
                    Session["cr"] = cr;
                    Response.Redirect("report.aspx");
                }
            }
        }
    }

    protected void btnadd_Click(object sender, EventArgs e)
    {
        int id = 0;
        string name = "";
        if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
        {
            id = int.Parse(Request.QueryString["id"].ToString());
            customer c = db.customer.FirstOrDefault(a => a.id == id);
            name = c.name.ToString();
        }
        float pay = 0, repay = 0;
        string typeName = "",titlen="";
        if (title.SelectedValue == "سداد")
        {
            typeName = "سداد";
            pay = float.Parse(value.Text);
           
        }
        else if (title.SelectedValue == "فاتوره")
        {
            typeName = "فاتوره";
            repay = float.Parse(value.Text);
        }
        else
        {
            typeName = "مرتجع";
            pay = float.Parse(value.Text);
        }
      
        float daann = 0, mdeenn=0;
       
            string imgg = null;
            if (FileUpload1.HasFile)
            {
                HttpPostedFile postedFile1 = FileUpload1.PostedFile;
                
                    Random generator = new Random();
                    int r = generator.Next(100000000, 1000000000);
                    string fileName = "";
                    string ex = "";
                    ex = Path.GetExtension(postedFile1.FileName);
                    fileName = Path.GetFileName(r.ToString() + ex/*FileUpload1.PostedFile.FileName*/);
                    postedFile1.SaveAs(Server.MapPath("~/photos/") + fileName);
                imgg = r.ToString() + ex;


            }


        if (title.Text == "فاتوره")
        {
            customer_account ima = new customer_account
            {
                date = DateTime.Now
                ,
                title = title.Text,
                total = double.Parse(value.Text),
                customer_id = id,
                img = imgg
                ,
                pay = 0,
                repay = 0,
                user_id = uid,
                user_name = user
            };
            Mapper.addCustomeraccount(ima);
            ///Savee or bank
            if (RadioButtonList1.Items[0].Selected)
            {
                //insert into savee
                savee s = new savee
                {
                    daan = double.Parse(value.Text),
                    mdeen = 0,
                    date = DateTime.Now,
                    roleType = roleType,
                    title = "فاتورة للعميل" + name,
                    user_id = uid,
                    user_name = user
                };
                db.savee.Add(s);
                db.SaveChanges();
            }
            else {
                // insert into  bank account
                if (DropDownList1.SelectedValue != "")
                {
                     bank_account ss = new bank_account
                    {
                        bank_name = DropDownList1.SelectedItem.ToString(),bank_id=DropDownList1.SelectedValue,datep=DateTime.Now
                        ,title= "ايداع",
                        typeRole=roleType,user_id=uid,daan= double.Parse(value.Text),
                        mdeen=0
                    };
                    db.bank_account.Add(ss);
                    db.SaveChanges();
                }
                else Response.Write("<script>alert('اختار البنك')</script>");

            }
        }
        else if (title.Text == "سداد")
        {
            customer_account ima = new customer_account
            {
                date = DateTime.Now
                ,
                title = title.Text,
                //total = double.Parse(value.Text),
                customer_id = id,
                img = imgg,
                pay = pay,
                repay = repay,
                user_id = uid,
                user_name = user

            };
            Mapper.addCustomeraccount(ima);
            #region bank choose
            ///Savee or bank
            if (RadioButtonList1.Items[0].Selected)
            {
                //insert into savee
                savee s = new savee
                {
                    daan = double.Parse(value.Text),
                    mdeen = 0,
                    date = DateTime.Now,
                    roleType = roleType,
                    title = "سداد للعميل" + name,
                    user_id = uid,
                    user_name = user
                };
                db.savee.Add(s);
                db.SaveChanges();
            }
            else
            {
                // insert into  bank account
                if (DropDownList1.SelectedValue != "")
                {
                   // int s1 = int.Parse(DropDownList1.SelectedValue);
                    bank_account ss = new bank_account
                    {
                        bank_name = DropDownList1.SelectedItem.ToString(),
                        bank_id = DropDownList1.SelectedValue,
                        datep = DateTime.Now
                        ,
                        title = "ايداع",
                        typeRole = roleType,
                        user_id = uid,
                        daan = double.Parse(value.Text),
                        mdeen = 0
                    };
                    db.bank_account.Add(ss);
                    db.SaveChanges();
                }
                else Response.Write("<script>alert('اختار البنك')</script>");

            }



            #endregion
        }
        else if (title.Text == "مرتجع")
        {
            customer_account ima = new customer_account
            {
                date = DateTime.Now
                ,
                title = title.Text,
                // total = double.Parse(value.Text),
                customer_id = id,
                img = imgg,
                pay = pay,
                repay = repay,
                user_id = uid,
                user_name = user

            };
            Mapper.addCustomeraccount(ima);
            #region bank choose
            ///Savee or bank
            if (RadioButtonList1.Items[0].Selected)
            {
                //insert into savee
                savee s = new savee
                {
                    daan = 0,
                    mdeen = double.Parse(value.Text),
                    date = DateTime.Now,
                    roleType = roleType,
                    title = "مرتجع للعميل" + name,
                    user_id = uid,
                    user_name = user
                };
                db.savee.Add(s);
                db.SaveChanges();
            }
            else
            {
                // insert into  bank account
                if (DropDownList1.SelectedValue != "")
                {
                    // int s1 = int.Parse(DropDownList1.SelectedValue);
                    bank_account ss = new bank_account
                    {
                        bank_name = DropDownList1.SelectedItem.ToString(),
                        bank_id = DropDownList1.SelectedValue,
                        datep = DateTime.Now
                        ,
                        title = "سحب",
                        typeRole = roleType,
                        user_id = uid,
                        daan = 0,
                        mdeen = double.Parse(value.Text)
                    };
                    db.bank_account.Add(ss);
                    db.SaveChanges();
                }
                else Response.Write("<script>alert('اختار البنك')</script>");

            }



            #endregion
        }
        Response.Redirect("AccountCustomer.aspx?id=" + id);
        
      
    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
       
    }

    protected void RadioButtonList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        if(RadioButtonList1.SelectedValue!="")
        {
            if(title.Text== "سداد" && RadioButtonList1.SelectedItem.ToString() == "بنك")
            {
                importerss.Visible = true;
            }
            if (RadioButtonList1.SelectedItem.ToString() == "بنك")
            { DropDownList1.Visible = true; }

        }
    }
}