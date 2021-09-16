using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ImporterHistory : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "", user = "";
    public static int uid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }

        if (Session["name"] != null && Session["uid"] != null)
        {
            user = Session["name"].ToString();
            uid = int.Parse(Session["uid"].ToString());
        }
        else { Response.Redirect("login.aspx"); }

    }
}