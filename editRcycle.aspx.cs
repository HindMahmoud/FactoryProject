using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class editRcycle : System.Web.UI.Page
{
    public static string roleType = "", username = "";
    public static int userid = 0;
    public static FactoryDBEntities db = new FactoryDBEntities();
    public int idinv=0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["name"] != null && Session["roleType"] != null)
        {
            username = Session["name"].ToString();
            roleType = Session["roleType"].ToString();
            userid = int.Parse(Session["uid"].ToString());
        }
        else Response.Redirect("login.aspx");
        if (!IsPostBack)
        {
            if (!IsPostBack)
            { functionFillDropDown();

                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edit"])))
                {

                    int imppid = int.Parse(Request.QueryString["edit"].ToString());
                    idinv = imppid;
                    var t = (from s in db.destroy_invoices where s.rec_id == imppid select s).FirstOrDefault();
                    //invoice_total.Text = t.total.ToString();
                    invid.Text = imppid.ToString();
                    run_pricetxt.Text = t.running_price.ToString();
                    DropDownList1.SelectedValue = t.recycled_item.ToString();
                    qty.Text = t.recycled_quantity.ToString();
                    
                    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
                    {
                        int x = int.Parse(Request.QueryString["delitem"].ToString());
                        var tt = db.destroy_inv.Where(a => a.id == x).FirstOrDefault();
                        db.destroy_inv.Remove(tt);
                        db.SaveChanges();
                        Response.Redirect("editRcycle.aspx?edit="+t.id);
                       
                    }
                    float total = 0;
                    int id = idinv;
                    var alldestroyitems = db.destroy_inv.Where(a => a.roleType == roleType && a.inv_id == id).ToList();
                    if (alldestroyitems != null)
                    {
                        foreach (var tr in alldestroyitems)
                        {
                            total += float.Parse(tr.item_total.ToString());
                        }
                        invoice_total.Text = total.ToString();
                    }

                }
            }
        }
    }
    public void functionFillDropDown()
    {
        var t = (from ss in db.stock_destroy
                 where ss.typeRole == roleType
                 select ss).ToList();

        main_it.DataSource = t;
        main_it.DataValueField = "id_item";
        main_it.DataTextField = "product_name";
        main_it.DataBind();
        main_it.Items.Insert(0, String.Empty);

        var tt = (from ss in db.stock where ss.roleType == roleType select ss).ToList();
        DropDownList1.DataSource = tt;
        DropDownList1.DataValueField = "id";
        DropDownList1.DataTextField = "name";
        DropDownList1.DataBind();
        DropDownList1.Items.Insert(0, string.Empty);
      

    }

    protected void main_it_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (main_it.SelectedValue != "")
        {
            int id = int.Parse(main_it.SelectedValue);
            var d = db.stock.Where(a => a.roleType == roleType && a.id == id).FirstOrDefault();
            if (d != null)
            {
                buyPrice.Text = d.buy_price.ToString();
            }

        }
    }

    protected void Button1_Click1(object sender, EventArgs e)
    { //insert into inv destroy table , note that new item will add it to invoice
            int idvalue = int.Parse(main_it.SelectedValue);
            var stockbuyprice = db.stock.Where(a => a.id == idvalue).FirstOrDefault();
            destroy_inv s = new destroy_inv
            {
                stat = 0,
                prod_name = main_it.SelectedItem.ToString(),
                quant = float.Parse(quan.Text),
                prod_id = int.Parse(main_it.SelectedValue),
                roleType = roleType,
                inv_id = int.Parse(invid.Text),
                item_total = (float.Parse(quan.Text) * (stockbuyprice.buy_price))

            };
            db.destroy_inv.Add(s);
            db.SaveChanges();
        buyPrice.Text = quan.Text = main_it.SelectedValue = "";
       
        float total = 0;
        int id = int.Parse(invid.Text);
        var alldestroyitems = db.destroy_inv.Where(a => a.roleType == roleType && a.inv_id == id).ToList();
        if (alldestroyitems != null)
        {
            foreach (var t in alldestroyitems)
            {
                total += float.Parse(t.item_total.ToString());
            }
            invoice_total.Text = total.ToString();
        }
       
    }

    protected void Button1_Click(object sender, EventArgs e)
    {

        if (DropDownList1.SelectedValue != "")
        {
            int idd = int.Parse(DropDownList1.SelectedValue);
            float quant = float.Parse(qty.Text);
            int id = int.Parse(invid.Text);//id of invoice
            var r1 = (from ss in db.destroy_inv where ss.roleType == roleType && ss.stat == 0 && ss.inv_id == id select ss).ToList();
            if (r1 != null)
            {
                foreach (var ttt in r1)
                {
                    var dest = db.stock_destroy.Where(a => a.id_item == ttt.prod_id).FirstOrDefault();
                    if (dest != null)
                    {
                        dest.quantity = dest.quantity - ttt.quant;// decrease quantity of destroy invoice items from stock destroy table
                        db.SaveChanges();
                        ttt.stat = 1;
                        db.SaveChanges();
                    }
                }

            }
            else { Response.Write("<script>alert('برجاء ادخل صنف واحد علي الاقل للفاتورة')</script>"); return; }
            var r = db.stock.Where(s => s.roleType == roleType && s.id == idd).FirstOrDefault();
            r.quantity += quant;
            // update buy prce of item in stock table to running price plus total of invoice
            float new_buy_price = float.Parse(invoice_total.Text) + float.Parse(run_pricetxt.Text);
            r.buy_price = new_buy_price;
            db.SaveChanges();
            //update invoice destroy 
            var d = db.destroy_invoices.Where(a => a.id == id).FirstOrDefault();
            d.total = float.Parse(invoice_total.Text);
            d.recycled_item = int.Parse(DropDownList1.SelectedValue);
            d.recycled_item_name = DropDownList1.SelectedItem.ToString();
            d.running_price = float.Parse(run_pricetxt.Text);
            d.recycled_quantity = float.Parse(qty.Text);
            db.SaveChanges();

        }
        Response.Redirect("searchRecycle.aspx");
    }

}