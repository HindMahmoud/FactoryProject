using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class saleInvoice : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "", user = "";
    public static int userid = 0;
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
        // code.SelectText();
        code.Focus();
        SetFocus(code);


        if (Session["name"] != null)
        {
            user = Session["name"].ToString();
            userid = int.Parse(Session["uid"].ToString());
        }
        else { Response.Redirect("login.aspx"); }

        if (Session["role"].ToString() == "Specific permission")
        {
            TextBox1.Enabled = false;
        }
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }

        if (db.invoice.Count() > 0)
        {
            var imid = (from s in db.invoice where s.typeRole==roleType select s.inv_id).Max();
            invid.Text = (imid + 1).ToString();

        }
        else
        {
            invid.Text = "1";
        }


        int tt = int.Parse(invid.Text);
        var sum = (from s in db.invoice_items where s.inv_id == tt select s.NetTotal).Sum();

        total2.Text  = sum.ToString();
        if (!IsPostBack)
        {
            code.Focus();
            SetFocus(code);

            //Fill DDL
            var cliens = db.customer.Where(a => a.roleType == roleType).ToList();
            if (cliens != null)
            {
                ddlclient.DataSource = cliens;
                ddlclient.DataTextField = "name";
                ddlclient.DataValueField = "id";
                ddlclient.DataBind();

            }
            var st = (from a in db.stock where a.roleType == roleType select a).ToList();

            if (st != null)
            {
                name.DataSource = st;
                name.DataValueField = "id";
                name.DataTextField = "name";
                name.DataBind();
                name.Items.Insert(0, new ListItem(String.Empty, String.Empty));
            }
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
            {
                int x = int.Parse(Request.QueryString["delitem"].ToString());
                invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);
                db.invoice_items.Remove(it);
                db.SaveChanges();
                /// if there is destroy percentage//////
                string ss = invid.Text;
                Response.Redirect("saleInvoice.aspx");

            }

            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edititem"])))
            {
                int x = int.Parse(Request.QueryString["edititem"].ToString());
                invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);
                editss.Visible = true;
                qty.Text = it.quantity.ToString();
                price.Text = it.price.ToString();
                //getting code within id of product that stored in stock
                int prodid = int.Parse(it.prod_code);
                var codeproduct = db.stock.Where(a => a.roleType == roleType && a.id == prodid).FirstOrDefault();
                code.Text = codeproduct.code;
                string nn = invid.Text;
                name.Text = it.prod_name.ToString();
                int v =int.Parse( it.prod_code);
                stock stt = db.stock.FirstOrDefault(a => a.id == v);
                name.SelectedValue = stt.id.ToString();
                addbtn.Visible = false;

            }
        }
    }

    protected void code_TextChanged(object sender, EventArgs e)
    {
        if (code.Text != "")
        {
            if (db.stock.Any(a => a.code == code.Text))
            {
                stock s = db.stock.FirstOrDefault(a => a.code == code.Text);
                if (s != null)
                {
                    string c = s.code.ToString();
                    name.ClearSelection(); //making sure the previous selection has been cleared
                    name.Items.FindByValue(s.id.ToString()).Selected = true;

                    name_SelectedIndexChanged1(sender, e);
                }
            }
        }
        
    }
    protected void addbtn_Click(object sender, EventArgs e)
    {  if (name.Text != "")
        {
            int cv = int.Parse(name.SelectedValue.ToString());
            if (db.stock.Any(a => a.id == cv))
            {
                stock s = db.stock.FirstOrDefault(a => a.id == cv);
             
                price.Text = s.price.ToString();
                TextBox2.Text = s.quantity.ToString();
               
                double currnetq = double.Parse(s.quantity.ToString());
                double q = double.Parse(qty.Text);

                double unitprice = double.Parse(price.Text);
                double totalprice = unitprice * q;
                //get id of product
                string c = code.Text;
                var r = db.stock.Where(a => a.roleType == roleType && a.code == c).FirstOrDefault();
                invoice_items im = new invoice_items
                {
                    inv_id = int.Parse(invid.Text),
                    prod_code = r.id.ToString(),//code.Text,
                    prod_name = name.SelectedItem.ToString(),
                    quantity = Math.Round(double.Parse(qty.Text), 4),
                    price = Math.Round(unitprice, 4),
                    total = Math.Round(totalprice, 4),
                    status = 0,
                    NetTotal = Math.Round(totalprice, 4),

                };
                Mapper.addinvoiceitems(im);

                TextBox1_TextChanged(sender, e);
                Response.Redirect("saleInvoice.aspx");
            }
        }
        
    }



    protected void name_SelectedIndexChanged1(object sender, EventArgs e)
    {
        if (name.Text != "")
        {
            int id = int.Parse(name.SelectedValue.ToString());
            stock st = db.stock.FirstOrDefault(a => a.id == id);
            if (st != null)
            {
                code.Text = st.code.ToString();

                price.Text = st.buy_price.ToString();
                TextBox2.Text = st.quantity.ToString();
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



    protected void btn_addImport_Click(object sender, EventArgs e)
    {
        int imp_id = int.Parse(invid.Text);
        var sum = (from s in db.invoice_items where s.status == 0 && s.inv_id == imp_id select s.NetTotal).Sum();
        if (sum == null)
        {
            MsgBox("ادخل صنف واحد علي الاقل", this.Page, this); return;
        }
        int customerID = 0; 
        string customerName ="";
        customerID = int.Parse(ddlclient.SelectedValue);
        customerName = ddlclient.SelectedItem.ToString();
        string imgg = null;
        if (FileUpload1.HasFile)
        {
            HttpPostedFile postedFile1 = FileUpload1.PostedFile;

            Random generator = new Random();
            int r = generator.Next(100000000, 1000000000);
            string fileName = "";
            string ex = "";
            ex = Path.GetExtension(postedFile1.FileName);
            fileName = Path.GetFileName(r.ToString() + ex/*FileUpload1.PostedFile.FileName*/);
            postedFile1.SaveAs(Server.MapPath("~/photos/") + fileName);
            imgg = r.ToString() + ex;
        }

        int user_id = (from f in db.users where f.user_name == user select f.id).FirstOrDefault();

        var sumv = (from s in db.invoice_items where s.status == 0 && s.inv_id == imp_id select s.NetTotal).Sum();
        float dis = 0;
        if (TextBox1.Text != "")
        {
            dis = float.Parse(TextBox1.Text);
        }
        double? total2var = (sumv - (dis / 100 * sumv));//double.Parse(total2.Text);
        int idcasher = 0;
        string casher = "";
        if (casherddl.SelectedValue != "")
        {
            idcasher = int.Parse(casherddl.SelectedValue);
            casher = casherddl.SelectedItem.ToString();
        }
      
        double? payval = total2var;
        if (pay.Text != "")
        { payval= double.Parse(pay.Text); }

        invoice i = new invoice
        {
            id = int.Parse(invid.Text),
            total = sum,
            date = DateTime.Now,
            discount = Math.Round(dis, 4),
            Nettotal = Math.Round(double.Parse(total2var.Value.ToString()), 4),//sum of produects minus discount
            payed= payval,
            customer_id = customerID,
            customer_name = customerName,
            user_name = user,
            user_id = user_id,
            img = imgg,
            typeRole = roleType
            ,casherid=idcasher,
            casherName=casher,inv_id=int.Parse(invid.Text)
        };
        Mapper.addinvoice(i);

        var v = db.invoice_items.Where(n => n.status == 0 && n.inv_id == imp_id).Distinct().ToList();
        foreach (var item in v)
        {
            int idproduct = int.Parse(item.prod_code);
            double quantity = Math.Round(double.Parse(item.quantity.ToString()), 4);

            var product = db.stock.FirstOrDefault(a => a.id == idproduct);
            product.quantity = product.quantity - quantity;

           // descrease destory percentage from stock
            var destroyitem = db.stock_destroy.Where(a => a.id_item == product.id && a.typeRole == roleType).FirstOrDefault();
            if (destroyitem != null)
            {
                product.quantity += (destroyitem.quantity - product.perc_destroy / 100 * destroyitem.quantity);
                db.SaveChanges();
               
            }
            db.SaveChanges();
        }

        v.ForEach(a => a.status = 1);
        db.SaveChanges();
        
        if (ddlclient.SelectedItem.ToString() != "كاش")
        { customer_account ima = new customer_account
            {
                inv_id = int.Parse(invid.Text),
                customer_id = customerID,
                user_id = userid,
                user_name = user,
                date = DateTime.Now,
                total = Math.Round(double.Parse(total2.Text), 4),
                pay = Math.Round(double.Parse(pay.Text), 4),//سدده
                repay = 0,//عليه
                title = "فاتوره"
            };
            Mapper.addCustomeraccount(ima);
          
        }
        else {//سداد الفاتورة كاش
            if (RadioButtonList2.SelectedValue == "2")
            {int s=int.Parse(DropDownList1.SelectedValue);
                var bankid = db.bank.Where(a=>a.id==s).FirstOrDefault();
                bank_account ss = new bank_account
                {
                    bank_id=bankid.id.ToString(),
                    bank_name=bankid.BankName,
                    datep=DateTime.Now,
                    typeRole=roleType,
                    user_id=user_id,
                    title="ايداع",
                    daan= payval,
                    mdeen=0,

                };
                db.bank_account.Add(ss);
                db.SaveChanges();
            }
            else
            {
                savee sa = new savee
                {
                    user_id = userid,
                    user_name = user,
                    date = DateTime.Now,
                    Operation_type = "مبيعات",
                    title = "فاتورة بيع رقم " + invid.Text,
                    roleType = roleType,
                    item_id = invid.Text.ToString(),
                    mdeen = 0,
                    daan = payval// i.Nettotal,
                };
                db.savee.Add(sa);
                db.SaveChanges();
            }
        }
       
        Session["flag"] = 0;
       
        string q = @"select *,[casherName], it.total as tot , it.[Nettotal] as tot2 from invoice inv join invoice_items it
on inv.inv_id= it.inv_id join customer imp on imp.id=inv.customer_id  
where inv.inv_id=" + imp_id+" and imp.roleType='"+roleType+"' and inv.typeRole='"+roleType+"'";
        string cr = "SaleInvoiceR.rpt";
        Session["query"] = q;
        Session["cr"] = cr;
        Response.Redirect("report.aspx");
        Page.ClientScript.RegisterStartupScript(this.GetType(), "OpenWindow", "window.Open('SalesInvoiceR.rpt','_newtab'));", true);



    }



    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {
        if (TextBox1.Text != "" /*&& TextBox1.Text != "0"*/)
        {
            int id = int.Parse(invid.Text);
            var sum = (from s in db.invoice_items where s.status == 0 && s.inv_id == id select s.total).Sum();
            double x = double.Parse(TextBox1.Text);
            total2.Text = (sum - (x / 100 * sum)).ToString();
        }
    }
 protected void add_Click(object seder, EventArgs e)
    {
        if (customere.Text != "")
        {
            DateTime? s = null;
           
            if (birthdate.Text != "")
                s = Convert.ToDateTime(birthdate.Text);
            float val = 0;
            if (initval.Text != "")
            { val = float.Parse(initval.Text); }
            customer c = new customer
            {
                name = customere.Text,
                phone = phone.Text,
                date = s,
                balance = val,
                roleType = roleType,
                address = address.Text,

            };
            Mapper.addcustomer(c);
            if (val > 0)
            {
                customer_account a = new customer_account
                { customer_id=c.id,date=DateTime.Now,user_name=user,user_id=userid,title="رصيد افتتاحي",pay=val,total=0,repay=0};
                Mapper.addCustomeraccount(a);
            }
            Response.Redirect("saleInvoice.aspx");

        }
    }
    protected void btnCancel_Click(object sender, EventArgs e)
    {
        Response.Redirect("saleInvoice.aspx");
    }
    protected void btnEdit_Click(object sender, EventArgs e)
    {
        int x = int.Parse(Request.QueryString["edititem"].ToString());
        double unitprice = double.Parse(price.Text);
        double totalprice = unitprice * double.Parse(qty.Text);
        invoice_items it = db.invoice_items.FirstOrDefault(a => a.id == x);
        it.quantity = double.Parse(qty.Text);
        it.price = unitprice;
        it.total = totalprice;
        it.NetTotal = totalprice;
        db.SaveChanges();
        // stock_destroy item = db.stock_destroy.Where(a => a.id_invoiceItem == x).FirstOrDefault();
        ////////////////////////////destory part////////////////
        //double perc = 0;
        //if (des_perc.Text != "") 
        //{
        //    perc = double.Parse(des_perc.Text);
        //    string nn = invid.Text;
        //    stock_destroy n = db.stock_destroy.Where(a=>a.inv_id==nn&&a.id_invoiceItem==it.id).FirstOrDefault();
        //    if (n == null)
        //    {
        //        stock_destroy des = new stock_destroy
        //        {
        //            date = DateTime.Now,
        //            inv_id = invid.Text,
        //            typeRole = roleType,
        //            user_id = userid,
        //            user_name = user,
        //            quantity = Math.Round(double.Parse(qty.Text), 4),
        //            product_id = int.Parse(it.prod_code),
        //            product_name = it.prod_name,
        //            destroy_percentage = perc,
        //            stat = false,
        //            id_invoiceItem = it.id//int.Parse(invid.Text.ToString())
        //        };
        //        db.stock_destroy.Add(des);
        //        db.SaveChanges();
        //    }
        //    else { n.destroy_percentage = perc; db.SaveChanges(); }
       // }

        
        Response.Redirect("saleInvoice.aspx");
    }

    protected void RadioButtonList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList2.SelectedValue == "2")
        {
            DropDownList1.Visible = true;
            var b = db.bank.Where(a => a.roleType == roleType).ToList();
            DropDownList1.DataSource = b;
            DropDownList1.DataValueField = "id";
            DropDownList1.DataTextField = "BankName";
            DropDownList1.DataBind();
        }
        else DropDownList1.Visible = false;
    }
}