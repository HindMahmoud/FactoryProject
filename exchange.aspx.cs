using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class exchange : System.Web.UI.Page
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
       

        //for sales 
        if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "Specific permission")
            {
                salesprice.Enabled = false;
            }
            if (Session["roleType"] != null) roleType = Session["roleType"].ToString();
        }
        else { Response.Redirect("login.aspx"); }
        
        if (db.invoice.Count() > 0)
        {
            var imid = (from s in db.invoice select s.id).Max();
            invid.Text = (imid + 1).ToString();

        }
        else
        {
            invid.Text = "1";
        }


        int tt = int.Parse(invid.Text);
        var sum = (from s in db.invoice_items where s.inv_id == tt select s.NetTotal).Sum();

        total2.Text = pay.Text = sum.ToString();

        //---end sales
        int iip = 1;
        if (db.returninv.Count() > 0)
        {
            var imidf = (from s in db.returninv select s.id).Max();
            iip = imidf + 1;
            impid.Text = (imidf + 1).ToString();
        }
        else
        {
            impid.Text = "1";

        }
        //---------to calculate total val of exchange---------
        var summation = (from s in db.return_items where s.status == 0 && s.return_id == iip select s.total).Sum();
        if (summation != null&&total2.Text!="")
        {
            totalval.Text = (double.Parse(total2.Text.ToString()) - double.Parse(summation.ToString())).ToString();
        }
            if (!IsPostBack)
        {

            //--for sales
            //var xx = (from i in db.setting select i.dis).FirstOrDefault();
            //if (xx != null)
            //{
            //    salesprice.Text = xx.ToString();
            //    TextBox5_TextChanged(sender, e);
            //}
            TextBox5_TextChanged(sender, e);

            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
            {
                int x = int.Parse(Request.QueryString["delitem"].ToString());


                invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);
                db.invoice_items.Remove(it);
                db.SaveChanges();
                Response.Redirect("exchange.aspx");

            }

            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edititem"])))
            {

                int x = int.Parse(Request.QueryString["edititem"].ToString());

                invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);
                
                editss.Visible = true;
                salesqty.Text = it.quantity.ToString();
                salesprice.Text = it.price.ToString();



                // else { MsgBox("ادخل السعر و الكميه",this.Page,this); }

            }



            //-------end sales



            //----for return ------
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
            {
                int x = int.Parse(Request.QueryString["delitem"].ToString());
                return_items it = db.return_items.FirstOrDefault(a => a.id == x);
                db.return_items.Remove(it);
                db.SaveChanges();
            }
            //else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edititem"])))
            //{
            //    int x = int.Parse(Request.QueryString["edititem"].ToString());
            //    return_items it = db.return_items.FirstOrDefault(a => a.id == x);
            //    qty.Text = it.quantity.ToString();

            //    price.Text = it.price.ToString();
            //    Button1.Text = "تعديل";

            //}
            //else
            //{
            //    int imppid = iip;
            //    var items = db.return_items.Where(a => a.status == 0&&a.return_id==imppid ).ToList();
            //    db.return_items.RemoveRange(items);
            //    db.SaveChanges();
            //}

        }
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
            else if (qty.Text == "")
            { MsgBox("ادخل الكميه", this.Page, this); }
            else if (price.Text == "")
            { MsgBox("ادخل السعر ", this.Page, this); }
            else
            {
                int id = int.Parse(items.SelectedValue.ToString());
                invoice_items inv = db.invoice_items.FirstOrDefault(a => a.id == id);
                Session["invId_return"] = inv_id.Text;
                double qqty = double.Parse(qty.Text);
                if (qqty > inv.quantity)
                {
                    MsgBox("خطأ في  الكميه", this.Page, this);
                }
                else
                {


                    double unitprice = double.Parse(price.Text);
                    double totalprice = unitprice * double.Parse(qty.Text);
                    //DateTime? xdate = null;
                    //if (ex_date.Value != "")
                    //{
                    //    xdate = Convert.ToDateTime(ex_date.Value);

                    //}
                    int itemid = int.Parse(items.Text);
                    var xcode = (from s in db.invoice_items where s.id == itemid select s.prod_code).FirstOrDefault();

                    return_items im = new return_items
                    {
                        return_id = int.Parse(impid.Text),
                        prod_code = xcode.ToString(),
                        prod_name = items.SelectedItem.ToString(),
                        quantity = double.Parse(qty.Text),
                        // min_quantity = int.Parse(qty.Text),
                        price = unitprice,
                        total = totalprice,
                        status = 0,
                        //ex_date = xdate
                    };
                    Mapper.addretuenitems(im);
                    /*name.Text = code.Text =*/
                    price.Text = qty.Text = "";
                    
                    int imp = int.Parse(impid.Text);
                    if (total2.Text != "")
                    {
                        double? o = double.Parse(total2.Text);
                        totalval.Text = (o - totalprice).ToString();
                    }
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
                else
                {
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

    protected void btn_addImport_Click(object sender, EventArgs e)
    {
       
    }

    protected void TextBox5_TextChanged(object sender, EventArgs e)
    {
        //if (TextBox5.Text != "" /*&& TextBox1.Text != "0"*/)
        //{
        //    int id = int.Parse(invid.Text);
        //    var sum = (from s in db.invoice_items where s.status == 0 && s.inv_id == id select s.total).Sum();
        //    var sum2 = (from s in db.invoice_items where s.status == 0 && s.inv_id == id select s.total2).Sum();


        //    double x = double.Parse(TextBox5.Text);
        //    total2.Text = (sum2 - (x / 100 * sum2)).ToString();


        //    var xx = (from i in db.setting select i.taxes).FirstOrDefault();
        //    if (total2.Text != "")
        //    {
        //        double j = double.Parse(total2.Text);
        //        //  total3.Text = (j + (xx / 100 * j)).ToString();
        //        pay.Text = (j + (xx / 100 * j)).ToString();
        //    }


        //}
    }

    protected void items_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (items.SelectedValue != "")
        {
            int id = int.Parse(items.SelectedValue.ToString());

            invoice_items inv = db.invoice_items.FirstOrDefault(a => a.id == id);
            qty.Text = inv.quantity.ToString();
            price.Text = inv.price.ToString();
        }
        else { qty.Text = price.Text = ""; }
    }

    protected void inv_id_TextChanged(object sender, EventArgs e)
    {
        if (inv_id.Text != "")
        {
            int f = int.Parse(inv_id.Text);

            if (db.invoice_items.Any(a => a.inv_id == f && a.status == 1 && a.quantity > 0))
            {
                var a = (from s in db.invoice_items where s.inv_id == f && s.status == 1 && s.quantity > 0 select s).ToList();
                items.DataTextField = "prod_name";
                items.DataValueField = "id";
                items.DataSource = a;



                items.DataBind();
                items_SelectedIndexChanged(sender, e);
            }
            else
            {
                items.Items.Clear();

                items.DataSource = null;
                items.DataBind();
                items_SelectedIndexChanged(sender, e);

            }
        }
    }



    protected void code_TextChanged(object sender, EventArgs e)//فاتورة البيع
    {
        if (code.Text != "")
        {
            if (db.stock.Any(a => a.code == code.Text))
            {
                stock s = db.stock.FirstOrDefault(a => a.code == code.Text);
                var nameproduct = s.name;
                //name.Text = s.name.ToString();
                price.Text = s.price.ToString();
                salesqty.Text = s.quantity.ToString();
                qty.Text = "1";
                double currnetq = double.Parse(s.quantity.ToString());
                double q = double.Parse(qty.Text);
                //int inv = int.Parse(invid.Text);
                //double qx = 0;
                //var xsx = (from sx in db.invoice_items where sx.inv_id == inv && sx.prod_code == code.Text select sx).ToList();
                //if (xsx != null)
                //{
                //    qx = double.Parse(xsx.Sum(a => a.quantity).ToString());
                //}

                //if (currnetq < (q + qx))
                //{
                //    MsgBox("لاتوجد كميه ف المخزن", this.Page, this);
                //}
                //else
                //{

                double unitprice = double.Parse(price.Text);
                double totalprice = unitprice * double.Parse(qty.Text);
               
                double total2 =  totalprice;


                invoice_items im = new invoice_items
                {
                    inv_id = int.Parse(invid.Text),
                    prod_code = code.Text,
                    prod_name = nameproduct,
                    quantity = Math.Round(double.Parse(qty.Text), 4),
                    price = Math.Round(unitprice, 4),
                    total = Math.Round(totalprice, 4),
                    status = 0,
                    
                    NetTotal = Math.Round(total2, 4)

                };
                Mapper.addinvoiceitems(im);
               
                Response.Redirect("exchange.aspx");
            }
        }
        //   }
    }
   // sales----------------------
    protected void button2_Click(object sender, EventArgs e)
    {
        //------for return
        int imp_idd = int.Parse(impid.Text);
        var summ = (from s in db.return_items where s.status == 0 && s.return_id == imp_idd select s.total).Sum();
        double summation_Of_return =double.Parse( summ.ToString());
        string user = "";
        if (Session["name"] != null)
        {
            user = Session["name"].ToString();
        }
        else { Response.Redirect("login.aspx"); }

        int user_id = (from f in db.users where f.user_name == user select f.id).FirstOrDefault();

        returninv i = new returninv
        {
            id = int.Parse(impid.Text),
            total = summ,
            date = DateTime.Now,
            user_name = user,
            user_id = user_id

        };
        Mapper.addreturn(i);
        var v = db.return_items.Where(n => n.status == 0 && n.return_id == imp_idd).ToList();

        v.ForEach(a => a.status = 1);
        db.SaveChanges();

        foreach (var item in v)
        {
            string code = item.prod_code.ToString();
            double quantity = double.Parse(item.quantity.ToString());

            var product = db.stock.FirstOrDefault(a => a.code == code);
            product.quantity = product.quantity + quantity;
            db.SaveChanges();


        }
        
       
        int invId = 0;
        if (Session["invId_return"] != null)
        {
            invId = int.Parse(Session["invId_return"].ToString());
        }
        else { MsgBox("ادخل عنصر المرتجع", this.Page, this);return; }
        int importer = invId; 


        invoice inn = db.invoice.FirstOrDefault(a => a.id == importer);

        int customer = int.Parse(inn.customer_id.ToString());
        var name = (from h in db.customer where h.id == customer select h.name).FirstOrDefault().ToString();

        if (name != "كاش")
        {

            customer_account ima = new customer_account
            {
                customer_id = customer,
                date = DateTime.Now,
                total= summ,
                pay=summ*(-1),
               // repay = double.Parse(totalval.Text),
                title = "مرتجع"
            };
            Mapper.addCustomeraccount(ima);
        }
       
        //end return








        //////////////---------for sales--------------///////////////////////
        int imp_id = int.Parse(invid.Text);
        var sum = (from s in db.invoice_items where s.status == 0 && s.inv_id == imp_id select s.total).Sum();
        var d = (from m in db.customer_account where m.inv_id==imp_id select m).FirstOrDefault();
       // int importer = int.Parse(d.customer_id.ToString());
        string importer_n = (from o in db.customer where o.id == importer select o.name).FirstOrDefault();
        
         //var name = (from h in db.customer where h.id == importer select h.name).FirstOrDefault().ToString();
      

        string imgg = null;
        
       // int user_id = (from f in db.users where f.user_name == user select f.id).FirstOrDefault();
       
        double discount = 0;
        if (salesprice.Text != "")
        {
            discount = double.Parse(salesprice.Text);
        }
        double total2varr = double.Parse(sum.ToString()) - discount;


        invoice ii = new invoice
        {
            id = int.Parse(invid.Text),
            total = 0,
            date = DateTime.Now,
            //per = Math.Round(discount, 4),
            //total2 = Math.Round(total2varr, 4),
            //pay = Math.Round(total2varr, 4),
            customer_id = customer,
            customer_name = name,
            user_name = user,
            user_id = user_id,
            img = imgg,
          

        };
        Mapper.addinvoice(ii);
      
        var vvv = db.invoice_items.Where(n => n.status == 0 && n.inv_id == imp_id).Distinct().ToList();
        
        foreach (var item in vvv)
        {
            string code = item.prod_code.ToString();
            double quantity = Math.Round(double.Parse(item.quantity.ToString()), 4);

            var product = db.stock.FirstOrDefault(a => a.code == code);
            product.quantity = product.quantity - quantity;
            db.SaveChanges();
        }
        vvv.ForEach(a => a.status = 1);
        db.SaveChanges();
       
            string q = @"select *,[casherName], it.total as tot , it.[Nettotal] as tot2 from invoice inv join invoice_items it
on inv.id= it.inv_id join customer imp on imp.id=inv.customer_id  
where inv.id=" + invid.Text + " ";
            string cr = "SaleInvoiceR.rpt";
            Session["query"] = q;
            Session["cr"] = cr;
            Response.Redirect("report.aspx");
           
            double vaal =0;
            if (summation_Of_return != 0 && total2.Text != "")
            {
               vaal = (double.Parse(total2.Text.ToString()) - summation_Of_return);
            }
            
            if (vaal > 0)//لو كان الصافي بتاع الجديد اكبر من المرتجع
            {
                
                savee bb = new savee
                {
                    daan = double.Parse(total2.Text.ToString()),//Math.Round(max_value + double.Parse(pay.Text), 4),
                    mdeen=summation_Of_return,
                date = DateTime.Now,
                    title = "فاتورة استبدال  ",
                   Operation_type="استبدال",
                   roleType=roleType,
                   user_id=user_id,user_name=user,

                };
                db.savee.Add(bb);
                db.SaveChanges();

            }
            else
            {//لو كان الجديد اقل من المرتجع
                savee bbb = new savee
                {
                   daan= double.Parse(total2.Text.ToString()),
                   mdeen=summation_Of_return,//Math.Round(max_value + double.Parse(pay.Text), 4),
                    date = DateTime.Now,
                    title = "فاتورة استبدال  ",
                    Operation_type = "استبدال",
                    roleType = roleType,
                    user_id = user_id,
                    user_name = user,

                };
                db.savee.Add(bbb);
                db.SaveChanges();

            }
           
            if (name != "كاش")
            {

                customer_account ima = new customer_account
                {
                    inv_id = int.Parse(invid.Text),
                    customer_id = importer,
                    date = DateTime.Now,
                    total = Math.Round(total2varr, 4),
                    pay = Math.Round(total2varr, 4),
                    title = "فاتوره"
                };
                Mapper.addCustomeraccount(ima);
            }
            // Response.Redirect("saleInvoice.aspx");
            Session["flag"] = 0;

            if (Session["role"] != null)
            {
                if (Session["role"].ToString() == "admin")
                {
                    Response.Redirect("exchange.aspx");
                }
                else
                {
                    Response.Redirect("Indexpage.aspx");
                }
            }
        

    }




   
    protected void btnCancel(object sender, EventArgs e)
    {
        Response.Redirect("exchange.aspx");
    }
    protected void btnEdit(object sender, EventArgs e)
    {
        int x = int.Parse(Request.QueryString["edititem"].ToString());
        double unitprice = double.Parse(salesprice.Text);
        double totalprice = unitprice * double.Parse(salesqty.Text);
        invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);


        it.quantity = double.Parse(salesqty.Text);
        it.price = unitprice;
        it.total = totalprice;
        it.NetTotal = totalprice;

        db.SaveChanges();
        Response.Redirect("exchange.aspx");

    }
}