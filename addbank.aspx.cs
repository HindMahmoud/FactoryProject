using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class addbank : System.Web.UI.Page
{
    public static FactoryDBEntities db = new FactoryDBEntities();
    public string roletype = "";
    public int suerID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null && Session["uid"] != null)
        {
            roletype = Session["roleType"].ToString();
            suerID = int.Parse(Session["uid"].ToString());
           

        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int x = int.Parse(Request.QueryString["id"].ToString());
                bank f = db.bank.FirstOrDefault(a => a.id == x);
                string fid = f.id.ToString();
                var bankacc = db.bank_account.Where(b => b.bank_id == fid).ToList();
                if (bankacc != null)
                {
                    db.bank_account.RemoveRange(bankacc);
                }
                db.bank.Remove(f);
                db.SaveChanges();

            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edit"])))
            {
                int x = int.Parse(Request.QueryString["edit"].ToString());
                bank f = db.bank.FirstOrDefault(a => a.id == x);
                name.Text = f.BankName;

                vale.Text = f.value.ToString();
                Button1.Text = "تعديل";

            }
        }
        }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Button1.Text != "تعديل")
        {
            bank s = new bank
            {
                BankName=name.Text,roleType=roletype,user_id=suerID,value=float.Parse(vale.Text)
            };
            db.bank.Add(s);
            db.SaveChanges();
            bank_account ss = new bank_account
            {
                bank_id = s.id.ToString(),
                bank_name = s.BankName,
                datep = DateTime.Now,
                typeRole = roletype,
                user_id = suerID,
                daan =float.Parse( vale.Text),
                mdeen = 0,
                title="رصيد افتتاحي"
            };
            db.bank_account.Add(ss);
            db.SaveChanges();

        }
        else
        {
            int x = int.Parse(Request.QueryString["edit"].ToString());
            bank f = db.bank.FirstOrDefault(a => a.id == x);
             f.BankName= name.Text ;
            string s = x.ToString();
            string newBalance = vale.Text;
              var bacc=  db.bank_account.Where(a => a.bank_id == s).FirstOrDefault();
            f.value = float.Parse(vale.Text);
            bacc.daan = f.value;
            db.SaveChanges();
        }
        Response.Redirect("addbank.aspx");
    }
}