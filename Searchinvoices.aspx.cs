using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class Searchinvoices : System.Web.UI.Page
{
    public static string roleType = "", user = "";
    public static int uid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        FactoryDBEntities db = new FactoryDBEntities();
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
        if (!IsPostBack)
        {
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["impid"])))
            {
                int x = int.Parse(Request.QueryString["impid"].ToString());
                var f = db.import_items.Where(a => a.imp_id == x).Distinct().ToList();
                var ff = db.import.Where(a => a.id == x).FirstOrDefault();

                foreach (var item in f)
                {
                    if (db.stock.Any(a => a.code == item.prod_code))
                    {
                        stock pro = db.stock.FirstOrDefault(a => a.code == item.prod_code);//increase quntity of deleted invoice in stock
                        pro.quantity = pro.quantity - item.quantity;
                        db.SaveChanges();
                    }
                }

                db.import_items.RemoveRange(f);
                db.SaveChanges();
               
                var importeracc = (from g in db.importer_account join n in db.importer on g.importer_id equals n.id where g.inv_id == x&&n.roleType==roleType select g).FirstOrDefault();
                if (importeracc != null)
                {
                    db.importer_account.Remove(importeracc);
                    db.SaveChanges();
                }
                else {
                    string fe = x.ToString();
                    var saveob = db.savee.Where(s => s.roleType == roleType && s.item_id == fe).FirstOrDefault();
                    if (saveob != null) { db.savee.Remove(saveob);db.SaveChanges(); } }

                db.import.Remove(ff);
                db.SaveChanges();

                Response.Redirect("Searchinvoices.aspx");

            }

            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["impprint"])))
            {
                int x = int.Parse(Request.QueryString["impprint"].ToString());
                string q = @"select *, it.total as tot  from import inv join import_items it on inv.id= it.imp_id join importer imp on imp.id=inv.importer_id
                 where it.imp_id=" + x + " ";
                string cr = "ImportinvoiceR.rpt";
                Session["query"] = q;
                Session["cr"] = cr;
                Response.Redirect("report.aspx");
            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["impprint2"])))
            {
                int x = int.Parse(Request.QueryString["impprint2"].ToString());
                string q = @"select *, it.total as tot , it.total2 as tot2 from import inv join import_items it on inv.id= it.imp_id join importer imp on imp.id=inv.importer_id join stock st on st.code = it.prod_code join main_item mt on st.main_id = mt.id
                where it.imp_id=" + x + " ";
                string cr = "CrystalReport.rpt";
                Session["query"] = q;
                Session["cr"] = cr;
                Response.Redirect("report.aspx");
            }



            
            //////////////-----------------Sales Invoices-----------------------------///////////////
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["invid"])))
            {
                int x = int.Parse(Request.QueryString["invid"].ToString());
                var f = db.invoice_items.Where(a => a.inv_id == x).Distinct().ToList();
                var ff = db.invoice.Where(a => a.id == x).FirstOrDefault();

                foreach (var item in f)
                {
                    if (db.stock.Any(a => a.code == item.prod_code))
                    {
                        stock pro = db.stock.FirstOrDefault(a => a.code == item.prod_code);//delete sales invoice will increase quantity in stock
                        pro.quantity = pro.quantity + item.quantity;
                        db.SaveChanges();
                    }
                 
                }

                db.invoice_items.RemoveRange(f);
                db.SaveChanges();

                var importeracc = (from g in db.customer_account join c in db.customer on g.customer_id equals c.id where g.inv_id == x&&c.roleType==roleType select g).FirstOrDefault();
                if (importeracc != null)
                {
                    db.customer_account.Remove(importeracc);
                    db.SaveChanges();
                }
                else
                {
                    string fe = x.ToString();
                    var saveob = db.savee.Where(s => s.roleType == roleType && s.item_id == fe).FirstOrDefault();
                    if (saveob != null) { db.savee.Remove(saveob); db.SaveChanges(); }
                }
                db.invoice.Remove(ff);
                db.SaveChanges();

                Response.Redirect("Searchinvoices.aspx");

            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["invprint"])))
            {
                int x = int.Parse(Request.QueryString["invprint"].ToString());

                string q = @"select *,[casherName], it.total as tot , it.[Nettotal] as tot2 from invoice inv join invoice_items it
                 on inv.inv_id= it.inv_id join customer imp on imp.id=inv.customer_id where inv.inv_id=" + x + " and imp.roleType='" + roleType + "' and inv.typeRole='" + roleType + "'";
                string cr = "SaleInvoiceR.rpt";
                Session["query"] = q;
                Session["cr"] = cr;
                Response.Redirect("report.aspx");
            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["invprint2"])))
            {
                int x = int.Parse(Request.QueryString["invprint2"].ToString());

                string q = @"select *, it.total as tot  from invoice inv join invoice_items it
 on inv.id= it.inv_id join customer imp on imp.id=inv.customer_id 
where it.inv_id="+x+" ";
                string cr = "CrystalReport2.rpt";
                Session["query"] = q;
                Session["cr"] = cr;
                Response.Redirect("report.aspx");
            }
          

        }
        }
}