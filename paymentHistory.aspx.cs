using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class paymentHistory : System.Web.UI.Page
{
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }

    }
}