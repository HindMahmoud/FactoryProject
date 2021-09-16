using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class addpayment : System.Web.UI.Page
{
  public static  FactoryDBEntities db = new FactoryDBEntities();
    public string roletype="",userName="";
    public int suerID = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null&&Session["name"]!=null&&Session["uid"]!=null)
        {
            roletype = Session["roleType"].ToString();
            suerID = int.Parse(Session["uid"].ToString());
            userName = Session["name"].ToString();

        }
            if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int x = int.Parse(Request.QueryString["id"].ToString());
                payment f = db.payment.FirstOrDefault(a => a.id == x);
                db.payment.Remove(f);
                db.SaveChanges();
             
            }
           else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["print"])))
            {
                int x = int.Parse(Request.QueryString["print"].ToString());
                string q = @"select * from payment where id=" + x ;
                string cr = "PaymentR.rpt";
                Session["query"] = q;
               
                Session["cr"] = cr;
                Response.Redirect("report.aspx");

            }
        }
        }

    protected void Button1_Click(object sender, EventArgs e)
    {
        string type_Of_payment = "";
        if (type.SelectedValue == "0")
        { type_Of_payment = "نثريه"; }
        else if (type.SelectedValue == "1")
            {
            type_Of_payment = "اساسيه";
        } 
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
            payment  p = new payment
            {
                title=name.Text,
                value=double.Parse(vale.Text),
                date=Convert.ToDateTime(date.Value),
                notes=notes.Text,
                type=type_Of_payment,
                roleType=roletype,
                user_id=suerID,
                user_name=userName
               
            };
            Mapper.addpayment(p);
        //if (RadioButtonList2.SelectedValue == "1")// if he choose savee
        //{
        //    savee s = new savee
        //    {
        //        Operation_type = "مصروفات",
        //        date = Convert.ToDateTime(date.Value)
        //        ,
        //        roleType = roletype,
        //        title = "مصروفات",
        //        user_id = suerID,
        //        user_name = userName,
        //        mdeen = 0,
        //        daan = float.Parse(vale.Text),

        //    };
        //    db.savee.Add(s);
        //    db.SaveChanges();
        //}
        //else
        //{
        //    if (bankddl.SelectedValue != "")
        //    {
               
        //        int idbank = int.Parse(bankddl.SelectedValue);
          
        //        var m = (from s in db.bank where s.id==idbank select s).FirstOrDefault();

        //        bank_account b = new bank_account
        //        { bank_id = idbank.ToString(),
        //            typeRole = roletype,
        //            bank_name = m.BankName,
        //            user_id = suerID,
        //            datep = DateTime.Now,
        //            mdeen = float.Parse(vale.Text),
        //            daan = 0,
        //            title="سحب"
        //        };
        //        db.bank_account.Add(b);
        //        db.SaveChanges();
        //    }
        //    //else Response.Write("<script>alert('برجاء اختيار بنك')</script>");
        //}
        //    Response.Redirect("addpayment.aspx");


      
    }



    protected void RadioButtonList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (RadioButtonList2.SelectedValue == "2")
        //{
        //    bankddl.Visible = true;
        //    var b = db.bank.Where(a => a.roleType == roletype).ToList();
        //    bankddl.DataSource = b;
        //    bankddl.DataValueField = "id";
        //    bankddl.DataTextField = "BankName";
        //    bankddl.DataBind();
        //    RequiredFieldValidator5.Enabled = true;

        //}
       // else bankddl.Visible = false;
    }
}