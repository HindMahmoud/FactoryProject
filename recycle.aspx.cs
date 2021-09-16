using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class recycle : System.Web.UI.Page
{public static string roleType="",username="";
    public static int userid = 0;
    public static FactoryDBEntities db = new FactoryDBEntities();
    protected void Page_Load(object sender, EventArgs e)
    {if (Session["name"] != null && Session["roleType"] != null)
        { username = Session["name"].ToString();
            roleType = Session["roleType"].ToString();
            userid = int.Parse(Session["uid"].ToString());
        }
        else Response.Redirect("login.aspx");
        if (db.destroy_invoices.Count() > 0)
        {
            var imid = (from s in db.destroy_invoices where s.roletype == roleType select s.id).Max();
            invid.Text = (imid + 1).ToString();

        }
        else
        {
            invid.Text = "1";
        }
        //getting total invoice in text 
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
        if (!IsPostBack)
        {
            var t = (from ss in db.stock_destroy
                     where ss.typeRole == roleType
                     select ss).ToList();
           
            main_it.DataSource = t;
            main_it.DataValueField = "id_item";
            main_it.DataTextField ="product_name";
            main_it.DataBind();
            main_it.Items.Insert(0, String.Empty);

            var tt = (from ss in db.stock where ss.roleType == roleType select ss).ToList();
            DropDownList1.DataSource = tt;
            DropDownList1.DataValueField = "id";
            DropDownList1.DataTextField = "name";
            DropDownList1.DataBind();
            DropDownList1.Items.Insert(0, String.Empty);


            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
            {
                int x = int.Parse(Request.QueryString["delitem"].ToString());
                destroy_inv it = db.destroy_inv.FirstOrDefault(a => a.id == x);
                db.destroy_inv.Remove(it);
                db.SaveChanges();
                Response.Redirect("recycle.aspx");
            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edititem"])))
            {
                int x = int.Parse(Request.QueryString["edititem"].ToString());
                destroy_inv it = db.destroy_inv.FirstOrDefault(a => a.id == x);
                
                qty.Text = it.quant.ToString();
               
                //getting code within id of product that stored in stock
                int prodid = int.Parse(it.prod_id.ToString());
                var codeproduct = db.stock.Where(a => a.roleType == roleType && a.id == prodid).FirstOrDefault();
                main_it.SelectedValue = codeproduct.id.ToString();
                buyPrice.Text = codeproduct.buy_price.ToString();
                quan.Text = it.quant.ToString();
                Button1.Text = "تعديل";

            }

        }

    }

   
    protected void Button1_Click(object sender, EventArgs e)
    {if (DropDownList1.SelectedValue != "")
        {
            int idd = int.Parse(DropDownList1.SelectedValue);
            float quant = float.Parse(qty.Text);
            int id = int.Parse(invid.Text);//id of invoice
            var r1= (from ss in db.destroy_inv where ss.roleType == roleType &&ss.stat==0&&ss.inv_id==id select ss).ToList();
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
            //insert into invoice destroy 
            destroy_invoices i = new destroy_invoices
            {
                date_destroy_inv = DateTime.Now,
                roletype = roleType,
                running_price = float.Parse(run_pricetxt.Text),
                user_id = userid, user_name = username, total = float.Parse(invoice_total.Text),
                recycled_item = int.Parse(DropDownList1.SelectedValue),
                recycled_item_name = DropDownList1.SelectedItem.ToString()
                , recycled_quantity =float.Parse( qty.Text),rec_id=int.Parse(invid.Text)
            };
            db.destroy_invoices.Add(i);
            db.SaveChanges();

        }
        Response.Redirect("recycle.aspx");
    }

    protected void Button1_Click1(object sender, EventArgs e)//adding to invoice destroy items table
    {
        if (Button1.Text != "تعديل")
        {
            //insert into inv destroy table 
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
           // Response.Redirect("recycle.aspx");
        }
        else {
            int x = int.Parse(Request.QueryString["edititem"].ToString());
            destroy_inv it = db.destroy_inv.FirstOrDefault(a => a.id == x);

            it.quant=float.Parse(qty.Text );

            //getting code within id of product that stored in stock
            int prodid = int.Parse(it.prod_id.ToString());
            var codeproduct = db.stock.Where(a => a.roleType == roleType && a.id == prodid).FirstOrDefault();
            main_it.SelectedValue = codeproduct.id.ToString();
            it.prod_id = int.Parse(main_it.SelectedValue);
            it.prod_name = main_it.SelectedItem.ToString();
            it.quant = float.Parse(quan.Text);
            it.item_total = float.Parse(buyPrice.Text) * float.Parse(quan.Text);
            db.SaveChanges();
         
        }
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
        Response.Redirect("recycle.aspx");
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
}