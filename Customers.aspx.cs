using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Customers : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int x = int.Parse(Request.QueryString["id"].ToString());
                customer f = db.customer.FirstOrDefault(a => a.id == x);
                db.customer.Remove(f);
                db.SaveChanges();
                Response.Redirect("Customers.aspx");

            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["editid"])))
            {
                int x = int.Parse(Request.QueryString["editid"].ToString());
                customer f = db.customer.FirstOrDefault(a => a.id == x);
                client.Text = f.name.ToString();
                phone.Text = f.phone.ToString();
                birthdate.Text = f.date.ToString();
                



                add.Text = "تعديل";


            }
        }
    }

    protected void add_Click(object sender, EventArgs e)
    {
        if(client.Text=="")
        {
            MsgBox("ادخل اسم العميل", this.Page, this);

        }
        if (birthdate.Text == "")
        {
            MsgBox("ادخل تاريخ الميلاد  ", this.Page, this);

        }
        else
        {
            if (add.Text == "تعديل")
            {
                int t = int.Parse(Request.QueryString["editid"].ToString());
                customer f = db.customer.FirstOrDefault(a => a.id == t);
                f.name = client.Text;
                f.date = Convert.ToDateTime(birthdate.Text);
                f.phone = phone.Text;
               
                db.SaveChanges();
                Response.Redirect("Customers.aspx");

            }
            else {
                customer c = new customer
                {
                    name = client.Text,
                    phone = phone.Text,
                    date = Convert.ToDateTime(birthdate.Text),
                    balance = 0,
                 
                };
                Mapper.addcustomer(c);
                Response.Redirect("Customers.aspx");
            }

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