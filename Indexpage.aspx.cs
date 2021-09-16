using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Indexpage : System.Web.UI.Page
{
    public static string roleType = "";
    protected void Page_PreInit(object sender, EventArgs e)
    {
        if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "Specific permission")
            {
                this.MasterPageFile = "~/test.master";
            }
            else { this.MasterPageFile = "~/Home.master"; }
        }
        else { Response.Redirect("login.aspx"); }
    }
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();

        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Request.QueryString["invprint"]))
            {
             int id=  int .Parse (Request.QueryString["invprint"]);
                string q = @"select *,[casherName], it.total as tot , it.[Nettotal] as tot2 from invoice inv join invoice_items it
                  on inv.inv_id= it.inv_id join customer imp on imp.id=inv.customer_id  
                  where inv.inv_id=" + id + " and imp.roleType='" + roleType + "' and inv.typeRole='" + roleType + "'";
                string cr = "SaleInvoiceR.rpt";
                Session["query"] = q;
                Session["cr"] = cr;
                Response.Redirect("report.aspx");

            }

        }
    }

   
}