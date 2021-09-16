using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class dailyReport : System.Web.UI.Page
{
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }

    }
    protected void btn4_Click(object sender, EventArgs e)
    {
        if (fromm.Text != "" && too.Text != "")
        {
            DateTime d1 = Convert.ToDateTime(fromm.Text);
            DateTime d2 = Convert.ToDateTime(too.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("dailyReport.aspx?date1=" + a + "&&date2=" + b);
        }
        
    }
}