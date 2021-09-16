using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class MoneyConvert : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "", username = "";
    public static int userid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["name"] != null && Session["roleType"] != null)
        {
            username = Session["name"].ToString();
            roleType = Session["roleType"].ToString();
            userid = int.Parse(Session["uid"].ToString());
        }
        else Response.Redirect("login.aspx");
        if (!IsPostBack)
        {
            var t = (from ss in db.bank where ss.roleType == roleType select ss).ToList();
            bankddl.DataSource = t;
            bankddl.DataValueField = "id";
            bankddl.DataTextField = "BankName";
            bankddl.DataBind();
            bankddl.Items.Insert(0, String.Empty);
        }

    }

    protected void btn_add_Click(object sender, EventArgs e)
    {
        float val =float.Parse( value.Text);
        if (bankddl.SelectedValue!="")
        {//----------------تحويل من خزنة للبنك---------------

            int bankid = int.Parse(bankddl.SelectedValue);
            bank_account bb = new bank_account
            {
               typeRole=roleType,
               bank_id=bankddl.SelectedValue,
               bank_name=bankddl.SelectedItem.ToString(),
               daan=val,
               mdeen=0,
               datep=DateTime.Now,
               title= "ايداع",
               user_id=userid
            };
            db.bank_account.Add(bb);
            db.SaveChanges();

            // savee
            savee b = new savee
            {
                date = DateTime.Now,
                roleType=roleType,
                user_id=userid,
                user_name=username,
                title="تحويل من خزنة لبنك"
                ,mdeen=val,
                daan=0,
            };
            db.savee.Add(b);
            db.SaveChanges();
            Response.Redirect("MoneyConvert.aspx");
        }
    }
}