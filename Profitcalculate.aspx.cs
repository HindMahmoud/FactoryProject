using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

using CrystalDecisions.CrystalReports.Engine;
using CrystalDecisions.Shared;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

public partial class Profitcalculate : System.Web.UI.Page
{
    SqlDataAdapter DA;
    SqlConnection con = new SqlConnection(@"data source=.;initial catalog=FactoryDB;integrated security=True; ");

    protected void Page_Load(object sender, EventArgs e)
    {
        string t="";
        con.Open();
        ReportDocument rptDoc = new ReportDocument();
        ////////////////////////////////main///////////////////////////////////////////
        DataSet ds = new DataSet();
       
        if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["total"])))
        {
            t = Request.QueryString["total"].ToString();
        }

        rptDoc.Load(Server.MapPath("~/Profits.rpt"));

        DataSet ds1 = new DataSet();
         string q1 = Session["query1"].ToString();
        DA = new SqlDataAdapter(q1, con);
        DA.Fill(ds1);
        rptDoc.Subreports[0].SetDataSource(ds1.Tables[0]);

        DataSet ds2 = new DataSet();
        string q2 = Session["query2"].ToString();
        DA = new SqlDataAdapter(q2, con);
        DA.Fill(ds2);
        rptDoc.Subreports[1].SetDataSource(ds2.Tables[0]);

        //ds.Tables[0].TableName = "pat";
      



        rptDoc.SetParameterValue("total", t);
        // rptDoc.VerifyDatabase();

        CrystalReportViewer1.ReportSource = rptDoc;
    }
}