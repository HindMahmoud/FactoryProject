using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class SearchAccount : System.Web.UI.Page
{
    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void btn1_Click(object sender, EventArgs e)
    {
        DateTime d1 = DateTime.Now.Date;
        DateTime d2 = d1.AddDays(1);
        string a = d1.ToShortDateString();
        string b = d2.ToShortDateString();

        Response.Redirect("money.aspx?date1="+a+"&&date2="+b);
    }

    protected void bt2_Click(object sender, EventArgs e)
    {

        DateTime d1 = DateTime.Now.Date;
        DateTime d2 = d1.AddDays(1);
        string a = d1.ToShortDateString();
        string b = d2.ToShortDateString();

        Response.Redirect("incomeHistory.aspx?date1=" + a + "&&date2=" + b);

    }

    protected void btn3_Click(object sender, EventArgs e)
    {

        DateTime d1 = DateTime.Now.Date;
        DateTime d2 = d1.AddDays(1);
        string a = d1.ToShortDateString();
        string b = d2.ToShortDateString();

        Response.Redirect("paymentHistory.aspx?date1=" + a + "&&date2=" + b);

    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }

    protected void btn4_Click(object sender, EventArgs e)
    {
        if(fromm.Text!=""&&too.Text!="")
        {
            DateTime d1 = Convert.ToDateTime(fromm.Text);
            DateTime d2 = Convert.ToDateTime(too.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("money.aspx?date1=" + a + "&&date2=" + b);
        }
        else
        {
            MsgBox("ادخل التاريخ", this.Page, this);
        }
    }

    protected void bt5_Click(object sender, EventArgs e)
    {
        if (fromm.Text != "" && too.Text != "")
        {
            DateTime d1 = Convert.ToDateTime(fromm.Text);
            DateTime d2 = Convert.ToDateTime(too.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("incomeHistory.aspx?date1=" + a + "&&date2=" + b);
        }
        else
        {
            MsgBox("ادخل التاريخ", this.Page, this);
        }
    }

    protected void btn6_Click(object sender, EventArgs e)
    {
        if (fromm.Text != "" && too.Text != "")
        {
            DateTime d1 = Convert.ToDateTime(fromm.Text);
            DateTime d2 = Convert.ToDateTime(too.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("paymentHistory.aspx?date1=" + a + "&&date2=" + b);
        }
        else
        {
            MsgBox("ادخل التاريخ", this.Page, this);
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (fromm.Text != "" && too.Text != "")
        {
            DateTime d1 = Convert.ToDateTime(fromm.Text);
            DateTime d2 = Convert.ToDateTime(too.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("customerHistory.aspx?date1=" + a + "&&date2=" + b);
        }
        else
        {
            MsgBox("ادخل التاريخ", this.Page, this);
        }
    }

    protected void Button2_Click(object sender, EventArgs e)
    {
        if (fromm.Text != "" && too.Text != "")
        {
            DateTime d1 = Convert.ToDateTime(fromm.Text);
            DateTime d2 = Convert.ToDateTime(too.Text);
            string a = d1.ToShortDateString();
            string b = d2.ToShortDateString();

            Response.Redirect("importerHistory.aspx?date1=" + a + "&&date2=" + b);
        }
        else
        {
            MsgBox("ادخل التاريخ", this.Page, this);
        }
    }
}