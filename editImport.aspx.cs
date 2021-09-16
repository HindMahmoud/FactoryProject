using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class editImport : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string username = "", roletype = "";
    public static int userid = 0;
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roletype = Session["roleType"].ToString();
        }

        if (Session["name"] != null && Session["uid"] != null)
        {
            username = Session["name"].ToString();
            userid = int.Parse(Session["uid"].ToString());
        }
        else { Response.Redirect("login.aspx"); }
        if (!IsPostBack)
        {
            var st = (from a in db.stock where a.roleType == roletype select a).ToList();
            if (st != null)
            {
                name.DataSource = st;
                name.DataValueField = "id";
                name.DataTextField = "name";
                name.DataBind();
                name.Items.Insert(0, new ListItem(String.Empty, String.Empty));

            }
           if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            { int imppid = int.Parse(Request.QueryString["id"].ToString());//رقم فاتورة الشراء 
                impid.Text = imppid.ToString();
                 import im = db.import.FirstOrDefault(a => a.id == imppid);
                sum.Text = im.total.ToString();
                TextBox1.Text = im.discount.ToString();
                pay.Text = im.payedvalue.ToString();
                TextBox1_TextChanged(sender, e);
                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["delitem"])))
                {
                    int x = int.Parse(Request.QueryString["delitem"].ToString());
                    message.Visible = true;
                    
                }
                
                else {
                    var items = db.import_items.Where(a => a.status == 0).ToList();
                    db.import_items.RemoveRange(items);
                    db.SaveChanges();
                }
                
            }
          
        }
      

    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        
            if (name.Text == "")
            { MsgBox("ادخل الاسم", this.Page, this); }
            else if (qty.Text == "")
            { MsgBox("ادخل الكميه", this.Page, this); }
            else if (price.Text == "")
            { MsgBox("ادخل السعر ", this.Page, this); }
            else
            {
                double unitprice = double.Parse(price.Text);
                double totalprice = unitprice * double.Parse(qty.Text);

                double total2 =  totalprice;
                import_items im = new import_items
                {
                    imp_id = int.Parse(impid.Text),
                    prod_code = name.Text,
                    prod_name = name.SelectedItem.ToString(),
                    quantity = Math.Round (double.Parse(qty.Text),4),
                    price =Math.Round( unitprice,4),
                    total =Math.Round (totalprice,4),
                    status = 0,
                   
                };
                Mapper.addimportitems(im);
                /*name.Text = code.Text =*/
                price.Text = qty.Text = "";
            }
        int i = int.Parse(impid.Text);
        var summ = (from s in db.import_items where s.imp_id ==i  select s.total).Sum();
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
        double dis = 0;
        import im = db.import.FirstOrDefault(a => a.id == imp_id);
        im.total =Math.Round (double.Parse(sum.Text),4);
        // --- to insure if there is discount or not----
        if ( TextBox1.Text != "")
        {
            dis = Math.Round(double.Parse(TextBox1.Text), 4);
        }
        double valuepayed= Math.Round(double.Parse(total2.Text), 4);
        if (pay.Text != "")
        { valuepayed = Math.Round(double.Parse(pay.Text), 4); }
        im.discount = dis;
        im.Net_total= Math.Round(double.Parse(total2.Text), 4);//الصافي
        im.user_id = userid;
        im.user_name = username;
        im.payedvalue = valuepayed;
        db.SaveChanges();

        var v = db.import_items.Where(n => n.status == 0 && n.imp_id == imp_id).Distinct().ToList();
        foreach (var item in v)
        {
            int code =int.Parse( item.prod_code);
            double quantity = Math.Round(double.Parse(item.quantity.ToString()),4);

            var product = db.stock.FirstOrDefault(a => a.id == code);
            product.quantity = product.quantity + quantity;
            db.SaveChanges();
        }

        v.ForEach(a => a.status = 1);
        db.SaveChanges();
      
       importer_account imac = db.importer_account.FirstOrDefault(a => a.inv_id == imp_id);//ده معناه ان الفاتورة كانت ف حساب مورد
        string i = impid.Text;
        savee saveoption = db.savee.FirstOrDefault(a => a.item_id == i&&a.Operation_type=="مشتريات");
        if (imac != null)
        {
            imac.daan = valuepayed;
            imac.mdeen = 0;
            db.SaveChanges();

        }

        else if (saveoption != null)// دخل تبع الخزنه 
        {
            saveoption.daan = 0;
            saveoption.mdeen = valuepayed;
            db.SaveChanges();

        }
        ///////////////////////////////////////////////
        string q = @"select *, it.total as tot  from import inv join import_items it on inv.id = it.imp_id join importer imp on imp.id = inv.importer_id
        where it.imp_id = " + imp_id + "";
            string cr = "ImportinvoiceR.rpt";
        Session["query"] = q;
        Session["cr"] = cr;
        Response.Redirect("report.aspx");

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
            var summ = (from s in db.import_items where  s.imp_id == id select s.total).Sum();
             if (summ == null)
            {
                sum.Text = "0";
            }
            else
            {
                sum.Text = summ.ToString();
            }
            double x = Math.Round(double.Parse(TextBox1.Text), 4);
            total2.Text = (summ - (x / 100 * summ)).ToString();
        }
    }


    protected void name_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (name.Text != "")
        {
            int d = int.Parse(name.Text);
            stock s = db.stock.FirstOrDefault(a => a.id == d);
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

                import_items it = db.import_items.FirstOrDefault(a => a.id == x );
                if (it != null)
                {
                    
                    if(it.status==1)//همسح عنصر من الفاتورة كان موجود 
                    {
                        int id = int.Parse(it.prod_code);
                        stock st = db.stock.FirstOrDefault(a => a.id == id);

                        st.quantity = st.quantity - it.quantity;
                        db.SaveChanges();
                    }
                    db.import_items.Remove(it);
                    db.SaveChanges();
                }
                
               
                var summ = (from s in db.import_items where s.imp_id == imppid select s.total).Sum();//مجموع كل عناصر الفاتورة سواء الجديدة او القديمة
                sum.Text = summ.ToString();

                TextBox1_TextChanged(sender, e);
                Response.Redirect("editImport.aspx?id=" + imppid);
            }
        }
    }

    protected void no_Click(object sender, EventArgs e)
    {

    }
}