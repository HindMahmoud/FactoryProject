using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ReportSearch : System.Web.UI.Page
{
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }

    }

    //protected void Button3_Click(object sender, EventArgs e)
    //{
    //    if (from1.Text != "" && to1.Text != "")
    //    {
    //        DateTime a = Convert.ToDateTime(from1.Text);
    //        string aa = a.ToString("yyyy-MM-dd HH:mm:ss.fff");
    //        DateTime b = Convert.ToDateTime(to1.Text);
    //        string bb = b.ToString("yyyy-MM-dd HH:mm:ss.fff");


    //        string q = @"select * from income where date >= '" + aa + "' and date <= '" + bb + "' ";
    //        string cr = "INcomesR.rpt";
    //        Session["query"] = q;
    //        Session["cr"] = cr;
    //        Response.Redirect("report.aspx");
    //    }
    //    else { MsgBox("enter date", this.Page, this); }
    //}
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (from2.Text != "" && to2.Text != "")
        {
            DateTime a = Convert.ToDateTime(from2.Text);
            string aa = a.ToString("yyyy-MM-dd HH:mm:ss.fff");
            DateTime b = Convert.ToDateTime(to2.Text);
            string bb = b.ToString("yyyy-MM-dd HH:mm:ss.fff");


            string q = @"select * from payment where date >= '" + aa + "' and date <= '" + bb + "'and roleType='"+roleType+"' ";
            string cr = "PaymentsR.rpt";
            Session["query"] = q;
            Session["cr"] = cr;
            Response.Redirect("report.aspx");
        }
        else { MsgBox("enter date", this.Page, this); }
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        if (from3.Text != "" && to3.Text != "")
        {
            DateTime a = Convert.ToDateTime(from3.Text);
            string aa = a.ToString("yyyy-MM-dd HH:mm:ss.fff");
            DateTime b = Convert.ToDateTime(to3.Text);
            string bb = b.ToString("yyyy-MM-dd HH:mm:ss.fff");


            string q = @"select * from import where date >= '" + aa + "' and date <= '" + bb + "' and roleType='"+roleType+"'";
            string cr = "ImportR.rpt";
            Session["query"] = q;
            Session["cr"] = cr;
            Response.Redirect("report.aspx");
        }
        else { MsgBox("enter date", this.Page, this); }
    }

    protected void Button4_Click(object sender, EventArgs e)
    {
        FactoryDBEntities db = new FactoryDBEntities();
        if (from4.Text != "" && to4.Text != "")
        {

            // DateTime a = Convert.ToDateTime(from4.Text);
            // string aa = a.ToString("yyyy-MM-dd HH:mm:ss.fff");
            // DateTime b = Convert.ToDateTime(to4.Text);
            // string bb = b.ToString("yyyy-MM-dd HH:mm:ss.fff");


            // string q1 = @"select * from savee where date >= '" + aa + "' and date <= '" + bb + "' and roleType='"+roleType+"'";
            // string q2 = @"select * from payment where date >= '" + aa + "' and date <= '" + bb + "' and  roleType='" + roleType + "'";

            //// string cr = "ImportR.rpt";
            // Session["query1"] = q1;
            // Session["query2"] = q2;

            // var incom = (from s in db.savee where s.date >= a && s.date <= b &&s.roleType==roleType select s.daan).Sum();
            // var incomq = (from s in db.savee where s.date >= a && s.date <= b&&s.roleType==roleType select s.mdeen).Sum();
            // double ss = double.Parse(incom.ToString()) - double.Parse(incomq.ToString());
            // if (incom ==null)
            // {
            //     incom = 0;
            // }

            // var pay = (from s in db.payment where s.date >= a && s.date <= b&&s.roleType==roleType select s.value).Sum();

            // if (pay == null)
            // {
            //     pay = 0;
            // }
            // double pro =ss - double.Parse( pay.ToString());

            //// Session["cr"] = cr;
            DateTime d1 = Convert.ToDateTime(from4.Text);
            DateTime d2 = Convert.ToDateTime(to4.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("money.aspx?date1=" + a + "&&date2=" + b);
        }
        else { MsgBox("enter date", this.Page, this); }
    }

    protected void Button5_Click(object sender, EventArgs e)
    {
        if (from5.Text != "" && to5.Text != "")
        {
            DateTime a = Convert.ToDateTime(from5.Text);
            string aa = a.ToString("yyyy-MM-dd HH:mm:ss.fff");
            DateTime b = Convert.ToDateTime(to5.Text);
            string bb = b.ToString("yyyy-MM-dd HH:mm:ss.fff");


            string q = @"select * from returninv where date >= '" + aa + "' and date <= '" + bb + "' and roleType='"+roleType+"'";
            string cr = "returnR.rpt";
            Session["query"] = q;
            Session["cr"] = cr;
            Response.Redirect("report.aspx");
        }
        else { MsgBox("enter date", this.Page, this); }
    }

    protected void Button6_Click(object sender, EventArgs e)
    {
        if (from6.Text != "" && to6.Text != "")
        {
            DateTime a = Convert.ToDateTime(from6.Text);
            string aa = a.ToString("yyyy-MM-dd HH:mm:ss.fff");
            DateTime b = Convert.ToDateTime(to6.Text);
            string bb = b.ToString("yyyy-MM-dd HH:mm:ss.fff");


            string q;
            if(name.Text=="")
            {
                q = @"select *, it.total as tot from invoice inv join invoice_items it on inv.id= it.inv_id where date >= '" + aa + "' and date <= '" + bb + "' ";
            }
            else
            {
                
                q = @"select  *, it.total as tot from invoice inv join invoice_items it on inv.id= it.inv_id where status=1 and date >= '" + aa + "' and date <= '" + bb + "' and prod_code='"+name.Text+"' ";

            }
            string cr = "ItemsSaleR.rpt";
            Session["query"] = q;
            Session["cr"] = cr;
            Response.Redirect("report.aspx");
        }
        else { MsgBox("enter date", this.Page, this); }
    }

    protected void Button7_Click(object sender, EventArgs e)
    {
        if (TextBox1.Text != "" && TextBox2.Text != "")
        {
            Response.Redirect("searchRecycle.aspx?date1="+TextBox1.Text+"&&date2="+TextBox2.Text);

        }
    }
}