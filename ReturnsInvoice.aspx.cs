using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class ReturnsInvoice : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
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
        if (Session["roleType"] != null )
        {
            roleType = Session["roleType"].ToString();
           
        }
        else Response.Redirect("login.aspx");
        if (db.returninv.Count() > 0)
        {
            var imid = (from s in db.returninv select s.id).Max();
            impid.Text = (imid + 1).ToString();
        }else
        {
            impid.Text = "1";
        }
        if (!IsPostBack)
        {
            //DropDownList1.SelectedValue="2";
           

            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
            {
                int x = int.Parse(Request.QueryString["delitem"].ToString());
                return_items it = db.return_items.FirstOrDefault(a => a.id == x);
                db.return_items.Remove(it);
                db.SaveChanges();
            }
          
            else {
                var items = db.return_items.Where(a => a.status == 0).ToList();
                db.return_items.RemoveRange(items);
                db.SaveChanges();
            }

        }
    }

    protected void items_SelectedIndexChanged(object sender, EventArgs e)
    {
        if(items.SelectedValue !="")
        {
            int id = int.Parse(items.SelectedValue.ToString());

            invoice_items inv = db.invoice_items.FirstOrDefault(a => a.id == id);
            qty.Text = inv.quantity.ToString();
            price.Text = inv.price.ToString();
        }
        else { qty.Text = price.Text=""; }
    }

    protected void inv_id_TextChanged(object sender, EventArgs e)
    {
        if (inv_id.Text != "")
        {
            int f = int.Parse(inv_id.Text);
            
            if (db.invoice_items.Any(a=>a.inv_id==f&&a.status==1 && a.quantity >0) )
            {
                var a = (from s in db.invoice_items where s.inv_id==f && s.status ==1 && s.quantity>0 select s).ToList();
                items.DataTextField = "prod_name";
                items.DataValueField = "id";
                items.DataSource = a;
                items.DataBind();
                items_SelectedIndexChanged(sender, e);
            }
            else {
                items.Items.Clear();
                
                items.DataSource = null;
                items.DataBind();
                items_SelectedIndexChanged(sender, e);

            }
        }
    }

    protected void btn_addImport_Click(object sender, EventArgs e)
    {       int imp_id = int.Parse(impid.Text);
            var sum = (from s in db.return_items where s.status == 0 && s.return_id == imp_id select s.total).Sum();
            string user = "";
            if (Session["name"] != null)
            {
                user = Session["name"].ToString();
            }
            else { Response.Redirect("login.aspx"); }

            int user_id = (from f in db.users where f.user_name == user select f.id).FirstOrDefault();

            returninv i = new returninv
            {
                inv_id = int.Parse(impid.Text),
                total = sum,
                date = DateTime.Now,
                user_name = user,
                user_id = user_id,
                roleType=roleType,
            };
            Mapper.addreturn(i);
            var v = db.return_items.Where(n => n.status == 0 && n.return_id == imp_id).ToList();

            v.ForEach(a => a.status = 1);
            db.SaveChanges();

            foreach (var item in v)
            {
                int idcode = int.Parse(item.prod_code.ToString());
                double quantity = double.Parse(item.quantity.ToString());

                var product = db.stock.FirstOrDefault(a => a.id == idcode);
            if (product != null)
            {
                product.quantity = product.quantity + quantity;
                db.SaveChanges();
            }
            }
            
        int importer = int.Parse(inv_id.Text);
        ////////////-------- invoice ------------

        invoice inn = db.invoice.FirstOrDefault(a => a.id == importer);

        int customer = int.Parse(inn.customer_id.ToString());
        var name = (from h in db.customer where h.id == customer select h.name).FirstOrDefault().ToString();
        double? payedd = sum;
        if (payed.Text != "")
        { payedd = double.Parse(payed.Text); }
        if (name != "كاش")
        {customer_account ima = new customer_account
            {
                customer_id = customer,
                date = DateTime.Now,
                repay = payedd,
                
                user_id=user_id,
                user_name=user,
                inv_id=int.Parse(impid.Text),
                title = "مرتجع"
            };
            Mapper.addCustomeraccount(ima);
        }
       
        savee ss = new savee
        {date=DateTime.Now,
        item_id=impid.Text,
        Operation_type="مرتجع بيع",
        roleType=roleType,
        user_id=user_id,
        user_name=user,
        daan=0,mdeen=payedd
        ,title="مرتجع بيع"
        };
        db.savee.Add(ss);
        db.SaveChanges();
        Response.Redirect("ReturnsInvoice.aspx");

    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }
    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Button1.Text != "تعديل")
        {
            if (items.Text == "")
            { MsgBox("ادخل الاسم", this.Page, this); }
       
            else
            {
                int id = int.Parse(items.SelectedValue.ToString());
                invoice_items inv = db.invoice_items.FirstOrDefault(a => a.id == id);
                double qqty = double.Parse(qty.Text);
                if (qqty > inv.quantity)
                {
                    MsgBox("خطأ في  الكميه", this.Page, this);
                }
                else {double unitprice = double.Parse(price.Text);
                    double totalprice = unitprice * double.Parse(qty.Text);
                    int itemid = int.Parse(items.Text);
                    var xcode = (from s in db.invoice_items where s.id == itemid select s.prod_code).FirstOrDefault();
                    return_items im = new return_items
                    {
                        return_id = int.Parse(impid.Text),
                        prod_code = xcode.ToString(),
                        prod_name = items.SelectedItem.ToString(),
                        quantity = double.Parse(qty.Text),
                      
                        price = unitprice,
                        total = totalprice,
                        status = 0,
                        roleType=roleType
                      
                    };
                    // Mapper.addretuenitems(im);
                    db.return_items.Add(im);
                    db.SaveChanges();
                    /*name.Text = code.Text =*/
                    price.Text = qty.Text = "";
                }
            }
        }
        else
        {
            if (qty.Text == "")
            { MsgBox("ادخل الكميه", this.Page, this); }
            else if (price.Text == "")
            { MsgBox("ادخل سعر الوحده ", this.Page, this); }
            else
            {

                int id = int.Parse(items.SelectedValue.ToString());
                invoice_items inv = db.invoice_items.FirstOrDefault(a => a.id == id);

                int qqty = int.Parse(qty.Text);
                if (qqty > inv.quantity)
                {
                    MsgBox("خطأ في  الكميه", this.Page, this);
                }
                else {
                    double unitprice = double.Parse(price.Text);
                    double totalprice = unitprice * double.Parse(qty.Text);

                    int x = int.Parse(Request.QueryString["edititem"].ToString());
                    return_items it = db.return_items.FirstOrDefault(a => a.id == x);

                    it.quantity = double.Parse(qty.Text);

                    it.price = unitprice;
                    it.total = totalprice;
                    //it.ex_date = xdate;
                    db.SaveChanges();
                    price.Text = qty.Text = "";
                    Button1.Text = "اضافه";


                }
            }
        }

    }

    //protected void qty_TextChanged(object sender, EventArgs e)
    //{
    //    if (items.SelectedValue != "")
    //    {
    //        int id = int.Parse(items.SelectedValue.ToString());

    //        invoice_items inv = db.invoice_items.FirstOrDefault(a => a.id == id);
    //        double? priceItems = inv.price;
    //        price.Text = (priceItems * int.Parse(qty.Text)).ToString();
    //    }
    //}
}