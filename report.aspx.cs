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
public partial class report : System.Web.UI.Page
{
    SqlDataAdapter DA;
    SqlConnection con = new SqlConnection(@"data source=.;initial catalog=FactoryDB;integrated security=True; ");

    protected void Page_Load(object sender, EventArgs e)
    {
        con.Open();
        ReportDocument rptDoc = new ReportDocument();
        ////////////////////////////////main///////////////////////////////////////////
        DataSet ds = new DataSet();
        
        //Session["CurrentName"] = name;
        string q= Session["query"].ToString();
        string cr = Session["cr"].ToString();
        ///////////



        rptDoc.Load(Server.MapPath("~/"+cr+""));
       
        DA = new SqlDataAdapter(q, con);
        DA.Fill(ds);
        //ds.Tables[0].TableName = "pat";
        rptDoc.SetDataSource(ds.Tables[0]);
        if(cr== "importeraznR.rpt" || cr== "customeraznR.rpt")
        {
            double value = double.Parse(Session["value"].ToString());

            rptDoc.SetParameterValue("val",value);
        }
        
        CrystalReportViewer1.ReportSource = rptDoc;
    }
}