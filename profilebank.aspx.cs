using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class profilebank : System.Web.UI.Page
{
    public static FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "",bankname="";
    public int x = 0,uid=0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
        {
            x = int.Parse(Request.QueryString["id"].ToString());
            bankname = db.bank.Where(a => a.id == x).FirstOrDefault().BankName ;
        }
        else Response.Redirect("addbank.aspx");
        if (Session["roleType"]!=null&&Session["uid"]!=null)
        {
            roleType = Session["roleType"].ToString();
            uid = int.Parse(Session["uid"].ToString());
        }
        else Response.Redirect("login.aspx");
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["del"]))
            {
                int xx =int.Parse( Request.QueryString["del"].ToString());
                bank_account s = db.bank_account.Where(a=>a.id==xx).FirstOrDefault();
                if (s != null)
                {
                    if (s.title == "رصيد افتتاحي")
                    {
                        bank se = db.bank.Where(sss => sss.id == x).FirstOrDefault();
                        se.value = 0;
                        db.SaveChanges();
                    }
                   db.bank_account.Remove(s);
                   db.SaveChanges();
                }
            }
            else if (!String.IsNullOrEmpty(Request.QueryString["edit"]))
            {
                int xx = int.Parse(Request.QueryString["edit"].ToString());
                bank_account s = db.bank_account.Where(a => a.id == xx).FirstOrDefault();
                if (s.mdeen == 0)//ايداع
                {
                    value.Text = s.daan.ToString();
                    title.SelectedValue = "1";

                }
                else
                {
                    value.Text = s.mdeen.ToString();
                    title.SelectedValue = "2";
                }//سحب
                btnadd.Text = "تعديل";
            }
        }
    }

    protected void btnadd_Click(object sender, EventArgs e)
    {
        if (btnadd.Text != "تعديل")
        {
            if (title.SelectedValue == "1")
            {
                // if he will put in account 
                bank_account s = new bank_account
                {
                    daan = float.Parse(value.Text),
                    mdeen = 0,
                    bank_id = x.ToString(),
                    datep = DateTime.Now,
                    bank_name = bankname,
                    user_id = uid,
                    title = "ايداع",
                    typeRole = roleType
                };
                db.bank_account.Add(s);
                db.SaveChanges();

            }
            else if (title.SelectedValue == "2")
            {
                bank_account s = new bank_account
                {
                    mdeen = float.Parse(value.Text),
                    daan = 0,
                    bank_id = x.ToString(),
                    datep = DateTime.Now,
                    bank_name = bankname,
                    user_id = uid,
                    title = "سحب",
                    typeRole = roleType
                };
                db.bank_account.Add(s);
                db.SaveChanges();

            }
        }
        else //تعديل
        { string t = "";
            float dan=0,mden=0;
            int xx = int.Parse(Request.QueryString["edit"]);
            var d = db.bank_account.Where(s=>s.id==xx).FirstOrDefault();
            if (title.SelectedValue == "1") { t = "ايداع";dan = float.Parse(value.Text); }
            else{ t = "سحب"; mden = float.Parse(value.Text); }
            d.title = t;
            d.daan = dan;d.mdeen = mden;db.SaveChanges();
        }
        Response.Redirect("profilebank.aspx?id="+x);
    }
}