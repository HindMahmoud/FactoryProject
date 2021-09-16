using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class searchRecycle : System.Web.UI.Page
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
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["del"])))
            {
                int x = int.Parse(Request.QueryString["del"].ToString());
                var items = db.destroy_inv.Where(a => a.inv_id == x).ToList();
                db.destroy_inv.RemoveRange(items);
                db.SaveChanges();
                destroy_invoices it = db.destroy_invoices.FirstOrDefault(a => a.id == x);
                db.destroy_invoices.Remove(it);
                db.SaveChanges();
                Response.Redirect("searchRecycle.aspx");
            }

            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edit"])))
            {
                int x = int.Parse(Request.QueryString["edit"].ToString());
                invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);
               
            }

        }

    }
}