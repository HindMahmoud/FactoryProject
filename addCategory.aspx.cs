using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class addCategory : System.Web.UI.Page
{
    public static FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int x = int.Parse(Request.QueryString["id"].ToString());
                category f = db.category.FirstOrDefault(a => a.id == x);
                db.category.Remove(f);
                db.SaveChanges();
                Response.Redirect("addCategory.aspx");

            }
        }
    }

    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }
    protected void add_Click(object sender, EventArgs e)
    { category c = new category { name = cat.Text };
            db.category.Add(c);
            db.SaveChanges();
            Response.Redirect("addCategory.aspx");
       
    }
}