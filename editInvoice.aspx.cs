using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class editInvoice : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public string roletype = "";
    protected void Page_Load(object sender, EventArgs e)
    {if (Session["roleType"] != null)
        {
            roletype = Session["roleType"].ToString();
        }
        if (!IsPostBack)
        {

            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
               
                int imppid = int.Parse(Request.QueryString["id"].ToString());
                var summ = (from s in db.invoice_items where s.inv_id == imppid select s.total).Sum();
                sum.Text = summ.ToString();
                impid.Text = imppid.ToString();
                invoice im = db.invoice.FirstOrDefault(a => a.inv_id == imppid);
                sum.Text = im.total.ToString();
                TextBox1.Text = im.discount.ToString();
                pay.Text = im.payed.ToString();
                TextBox1_TextChanged(sender, e);
                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
                {
                    int x = int.Parse(Request.QueryString["delitem"].ToString());
                    message.Visible = true;  
                }
                
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    { double qttty = double.Parse(qty.Text);
            double qttty2 = double.Parse(TextBox2.Text);
            string code = name.SelectedValue.ToString();
            int ids = int.Parse(impid.Text);
            if (qttty2 < qttty)
            {
                MsgBox("الكميه اقل من المتاح ف المخزن", this.Page, this);
            }
            
            else
            {
                double unitprice = double.Parse(price.Text);
                double totalprice = unitprice * double.Parse(qty.Text);
               
                double total2 = totalprice;
                //DateTime? xdate = null;
                //if (ex_date.Value != "")
                //{
                //    xdate = Convert.ToDateTime(ex_date.Value);

                //}

                if (db.invoice_items.Any(a => a.prod_code == code && a.inv_id == ids))
                {
                    invoice_items invvitem = db.invoice_items.FirstOrDefault(a => a.prod_code == code && a.inv_id == ids);
                    double oldQty = double.Parse(invvitem.quantity.ToString());
                    double newqty = oldQty + qttty;
                    if (qttty2 < newqty)
                    {
                        MsgBox("الكميه اقل من المتاح ف المخزن", this.Page, this);
                    }
                    else
                    {

                        invoice_items im = new invoice_items
                        {
                            inv_id = int.Parse(impid.Text),
                            prod_code = name.Text,
                            prod_name = name.SelectedItem.ToString(),
                            quantity = Math.Round(double.Parse(qty.Text), 4),
                            price = Math.Round(unitprice, 4),
                            total = Math.Round(totalprice, 4),
                            status = 0,
                           
                            NetTotal = Math.Round(total2, 4)
                            //ex_date = xdate
                        };
                        Mapper.addinvoiceitems(im);
                        /*name.Text = code.Text =*/
                        price.Text = qty.Text = "";
                    }
                }
                else
                {


                    invoice_items im = new invoice_items
                    {
                        inv_id = int.Parse(impid.Text),
                        prod_code = name.Text,
                        prod_name = name.SelectedItem.ToString(),
                        quantity = Math.Round(double.Parse(qty.Text), 4),
                        price = Math.Round(unitprice, 4),
                        total = Math.Round(totalprice, 4),
                        status = 0,
                       
                        NetTotal = Math.Round(total2, 4)
                        //ex_date = xdate
                    };
                    Mapper.addinvoiceitems(im);
                    /*name.Text = code.Text =*/
                    price.Text = qty.Text = "";
                }
            }
        
            int i = int.Parse(impid.Text);
            var summ = (from s in db.invoice_items where s.inv_id == i select s.NetTotal).Sum();
            sum.Text = summ.ToString();
            TextBox1_TextChanged(sender, e);
            name_SelectedIndexChanged(sender, e);
        
    }

    protected void code_TextChanged(object sender, EventArgs e)
    {
        //if(name.Text !="")
        //{
        //    if(db.stock.Any(a=>a.code==code.Text))
        //    {
        //        var namee = (from s in db.stock where s.code == code.Text select s.code).FirstOrDefault();
        //        name.Text = namee.ToString();
        //    }
        //    else { name.Text = ""; }
        //}
        //else { name.Text = ""; }
    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }



    protected void btn_addImport_Click(object sender, EventArgs e)
    {
        int imp_id = int.Parse(impid.Text);
        // var sum = (from s in db.import_items where s.status == 0 && s.imp_id == imp_id select s.total2).Sum();

        string user = "";
        if (Session["name"] != null)
        {
            user = Session["name"].ToString();


        }
        else { Response.Redirect("login.aspx"); }
       

        int user_id = (from f in db.users where f.user_name == user select f.id).FirstOrDefault();

        invoice im = db.invoice.FirstOrDefault(a => a.inv_id == imp_id);
      
        im.total = Math.Round(double.Parse(sum.Text),4);
        im.Nettotal = Math.Round(double.Parse(total2.Text),4);

        im.discount = Math.Round(double.Parse(TextBox1.Text),4);
        im.user_id = user_id;
        im.user_name = user;
        im.payed = Math.Round(double.Parse(pay.Text),4);
        db.SaveChanges();

        var v = db.invoice_items.Where(n => n.status == 0 && n.inv_id == imp_id).Distinct().ToList();
        foreach (var item in v)
        {
            string code = item.prod_code.ToString();
            double quantity = Math.Round(double.Parse(item.quantity.ToString()),4);

            var product = db.stock.FirstOrDefault(a => a.code == code);
            product.quantity = product.quantity - quantity;
            db.SaveChanges();
        }

        v.ForEach(a => a.status = 1);
        db.SaveChanges();
       
        customer_account imac = db.customer_account.FirstOrDefault(a => a.inv_id == imp_id);
        string d = imp_id.ToString();
        savee s = db.savee.Where(a => a.roleType == roletype && a.item_id == d && a.Operation_type == "مبيعات").FirstOrDefault();


        if (imac != null)
        {
            imac.pay = Math.Round(double.Parse(pay.Text), 4);
            imac.total = Math.Round(double.Parse(total2.Text), 4);
            db.SaveChanges();
        }
        else if (s!=null)
        {s.daan= Math.Round(double.Parse(total2.Text), 4);
            db.SaveChanges();

        } 
        ///////////////////////////////////////////////





        string q = @"select *,[casherName], it.total as tot , it.[Nettotal] as tot2 from invoice inv join invoice_items it
on inv.id= it.inv_id join customer imp on imp.id=inv.customer_id  
where inv.id=" + imp_id + "";
        string cr = "SaleInvoiceR.rpt";
        Session["query"] = q;
        Session["cr"] = cr;
        Response.Redirect("report.aspx");


        //Response.Redirect("newToread.aspx");
    }

    protected void DropDownList1_SelectedIndexChanged(object sender, EventArgs e)
    {
        //if (DropDownList1.Text != "")
        //{
        //    int f = int.Parse(DropDownList1.Text);
        //    var cat = (from j in db.importer where j.id == f select j.cat_id).FirstOrDefault();

        //    if (cat == 0)
        //    {
        //        var a = (from s in db.stock select s).ToList();
        //        name.DataTextField = "name";
        //        name.DataValueField = "code";
        //        name.DataSource = a;



        //        name.DataBind();
        //    }
        //    else
        //    {

        //        var a = (from s in db.stock where s.cat_id == cat select s).ToList();
        //        name.DataTextField = "name";
        //        name.DataValueField = "code";
        //        name.DataSource = a;



        //        name.DataBind();
        //    }
        //}
    }

    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {
        if (TextBox1.Text != "" /*&&TextBox1.Text !="0"*/)
        {
            int id = int.Parse(impid.Text);
            var summ = (from s in db.invoice_items where s.inv_id == id select s.total).Sum();
            
            if (summ == null)
            {
                sum.Text = "0";
            }
            else
            {
                sum.Text = summ.ToString();
            }
            double x = Math.Round(double.Parse(TextBox1.Text),4);
            total2.Text = (summ - (x / 100 * summ)).ToString();
        }
    }


    protected void name_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (name.Text != "")
        {
            stock s = db.stock.FirstOrDefault(a => a.code == name.Text);
            price.Text = s.price.ToString();


            TextBox2.Text = s.quantity.ToString();
            
        }
    }

    protected void yes_Click(object sender, EventArgs e)
    {
        if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
        {
            int imppid = int.Parse(Request.QueryString["id"].ToString());
            
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
            {
                int x = int.Parse(Request.QueryString["delitem"].ToString());
                // message.Visible = true;

                invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x );
                if (it != null)
                {
                    if (it.status == 1)
                    {
                        int dd = int.Parse(it.prod_code);
                        stock st = db.stock.FirstOrDefault(a => a.id == dd);

                        st.quantity = st.quantity + it.quantity;
                        db.SaveChanges();
                    }
                    db.invoice_items.Remove(it);
                    db.SaveChanges();
                    string d = impid.Text;
                   
                }
               
                var summ = (from s in db.invoice_items where s.inv_id == imppid select s.NetTotal).Sum();
                sum.Text = summ.ToString();
               



                TextBox1_TextChanged(sender, e);
                Response.Redirect("editInvoice.aspx?id=" + imppid);
            }
        }
    }
    protected void no_Click(object sender, EventArgs e)
    {
        message.Visible = false;
    }
}