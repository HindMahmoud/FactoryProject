using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class newToread : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "",user="";
    public static int uid = 0;
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
        code.Focus();
          this.Page.Form.DefaultFocus = code.ClientID;
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }
      
        if (Session["name"] != null&&Session["uid"]!=null)
        {
            user = Session["name"].ToString();
            uid = int.Parse(Session["uid"].ToString());
        }
        else { Response.Redirect("login.aspx"); }
        if (db.import.Count() > 0)
        {
            var imid = (from s in db.import where s.roleType==roleType select s.id).Max();
            impid.Text = (imid + 1).ToString();
        }
        else
        {
            impid.Text = "1";
        }


        int impidf = int.Parse(impid.Text);
        var sum = (from s in db.import_items where s.status == 0 && s.imp_id == impidf select s.total).Sum(); 

        total2.Text = sum.ToString();
        if (!IsPostBack)
        {//fill importer ddl
            var cliens = db.importer.Where(a => a.roleType == roleType).ToList();
            if (cliens != null)
            {
                DropDownList1.DataSource = cliens;
                DropDownList1.DataTextField = "name";
                DropDownList1.DataValueField = "id";
                DropDownList1.DataBind();

            }
            var st = (from a in db.stock where a.roleType==roleType select a).ToList();
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
               import_items it = db.import_items.FirstOrDefault(a => a.id == x);
                db.import_items.Remove(it);
                db.SaveChanges();
                Response.Redirect("newToread.aspx");
            }

            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["edititem"])))
            {       int x = int.Parse(Request.QueryString["edititem"].ToString());
                   import_items it = db.import_items.FirstOrDefault(a => a.id == x);

                editss.Visible = true;
                qty.Text = it.quantity.ToString();
                price.Text = it.price.ToString();
                name.Text = it.prod_name.ToString();
                string v = it.prod_name.ToString();
                stock stt = db.stock.FirstOrDefault(a => a.name == v);
                name.SelectedValue = stt.id.ToString();
               addbtn.Visible = false;
                
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


    protected void btnCancel(object sender, EventArgs e)
    {
        Response.Redirect("newToread.aspx");
    }
    protected void btnEdit(object sender, EventArgs e)
    {
        int x = int.Parse(Request.QueryString["edititem"].ToString());
        double unitprice = double.Parse(price.Text);
        double totalprice = unitprice * double.Parse(qty.Text);
        import_items it = db.import_items.FirstOrDefault(a => a.id == x);
        it.quantity = double.Parse(qty.Text);
        it.price = unitprice;
        it.total = totalprice;
        db.SaveChanges();
        Response.Redirect("newToread.aspx");

    }
    protected void btn_addImport_Click(object sender, EventArgs e)
    {

        int imp_id = int.Parse(impid.Text);
        var sum = (from s in db.import_items where s.status == 0 && s.imp_id == imp_id select s.total).Sum();
        if (sum == null)
        {
            Response.Write("<script>alert('ادخل الصنف')</script>");
            return;
        }
        int importe2r = int.Parse(DropDownList1.Text);
        string import_name = DropDownList1.SelectedItem.ToString();
        double total_after_dis = 0;
        double dis = 0;
        double sumation_of_product = double.Parse(sum.ToString());
        if (TextBox1.Text == "0"||TextBox1.Text=="")
        {
            total_after_dis =double.Parse(sum.ToString());
        }
        else
        {
            dis = double.Parse(TextBox1.Text);
            total_after_dis = double.Parse(sum.ToString())-dis;
        }
        double payval = total_after_dis;
        if (pay.Text != "")//سداد
        { payval = double.Parse(pay.Text); }
        import i = new import
        {
            id = int.Parse(impid.Text),
            Net_total = total_after_dis,
            date = Convert.ToDateTime(Text1.Text)
            , importer_id = importe2r,
            user_name = user,
            user_id=uid,
            importer_name=import_name,
           roleType=roleType,
           total=sumation_of_product,
           discount=dis,
           payedvalue=payval
        };
        Mapper.addimport(i);
        var v = db.import_items.Where(n => n.status == 0 &&n.imp_id==imp_id).Distinct().ToList();
        foreach(var item in v)
        {   int code =int.Parse( item.prod_code);
            double quantity = Math.Round(double.Parse(item.quantity.ToString()),4);
            var product = db.stock.FirstOrDefault(a => a.id == code);
            product.quantity = product.quantity + quantity;
            db.SaveChanges();
        }

        v.ForEach(a => a.status = 1);
        db.SaveChanges();
        int importer = int.Parse(DropDownList1.SelectedValue);
        var name = (from h in db.importer where h.id == importer select h.name).FirstOrDefault().ToString();

        if (name != "كاش")
        { importer_account ima = new importer_account
        {
            importer_id = importer,
            date = Convert.ToDateTime(Text1.Text),
            title = "فاتورة رقم "+impid.Text,
            inv_id = int.Parse(impid.Text),
            importer_name = name,
            user_id = uid,
            user_name = user,
            daan = Math.Round(payval,4),//Math.Round(double.Parse(total_after_dis.ToString()), 4),
            mdeen=0
        };
            Mapper.addIMPORTERaccount(ima);
        }
        else {
            if (RadioButtonList2.SelectedValue == "2")
            {
                int s = int.Parse(DropDownList2.SelectedValue);
                var bankid = db.bank.Where(a => a.id == s).FirstOrDefault();
                bank_account ss = new bank_account
                {
                    bank_id = bankid.id.ToString(),
                    bank_name = bankid.BankName,
                    datep = DateTime.Now,
                    typeRole = roleType,
                    user_id = uid,
                    title = "ايداع",
                    daan = Math.Round(payval, 4),
                    mdeen = 0,

                };
                db.bank_account.Add(ss);
                db.SaveChanges();
            }

            //will record invoice in savee directly if he choose save option
            else
            {
                savee ss = new savee
                {
                    roleType = roleType,
                    title = "فاتورة شراء رقم " + impid.Text,
                    item_id = impid.Text,
                    date = DateTime.Now,
                    user_id = uid,
                    user_name = user,
                    Operation_type = "مشتريات"
              ,
                    daan = 0,
                    mdeen = Math.Round(payval, 4) //total_after_dis,
                };
                db.savee.Add(ss);
                db.SaveChanges();
            }
        }
        ///////////////////////////////////////////////


        Session["flag"] = 0;


        //                string q = @"select *, it.total as tot ,it.total2 as tot2 from import inv join import_items it on inv.id= it.imp_id join importer imp on imp.id=inv.importer_id
        //where it.imp_id="+imp_id+" ";
        if (Session["role"].ToString() != "Specific permission")
        {
            ClientScript.RegisterStartupScript(GetType(), "Javascript", "refresh(); ", true);
            string q = @"select *, it.total as tot  from import inv join import_items it on inv.id= it.imp_id join importer imp on imp.id=inv.importer_id
        where it.imp_id=" + imp_id + "";
            string cr = "ImportinvoiceR.rpt";
            // string cr = "CrystalReport.rpt";

            Session["query"] = q;
            Session["cr"] = cr;
            Response.Redirect("report.aspx");

        }
        else { Response.Redirect("IndexPage.aspx"); } 
        //Response.Redirect("newToread.aspx");
    }

    
    protected void TextBox1_TextChanged(object sender, EventArgs e)
    {
        if(TextBox1.Text!="" /*&&TextBox1.Text !="0"*/)
        {
            int id = int.Parse(impid.Text);
            var sum = (from s in db.import_items where s.status == 0 && s.imp_id == id select s.total).Sum();
            double x = Math.Round(double.Parse(TextBox1.Text),4);
            total2.Text = (sum - (x / 100 * sum)).ToString();
        }
    }

    protected void code_TextChanged1(object sender, EventArgs e)
    {
        if (code.Text != "")
        { if (db.stock.Any(a => a.code == code.Text))
            { stock s = db.stock.FirstOrDefault(a => a.code == code.Text);
                string c = s.code.ToString();
                name.ClearSelection(); //making sure the previous selection has been cleared
                name.Items.FindByValue(s.id.ToString()).Selected = true;

                name_SelectedIndexChanged1(sender, e);
            }
        }
    }

    protected void name_SelectedIndexChanged1(object sender, EventArgs e)
    {
        if(name.Text!="")
        {
            int id = int.Parse(name.SelectedValue.ToString());
            stock st = db.stock.FirstOrDefault(a => a.id == id);
            code.Text = st.code.ToString();
            
            price.Text = st.buy_price.ToString();
            TextBox2.Text = st.quantity.ToString();
        }
    }

    protected void addbtn_Click(object sender, EventArgs e)
    {
        if (name.Text != "")
        { int c = int.Parse( name.SelectedValue.ToString());
            if (db.stock.Any(a => a.id == c))
            {
                stock s = db.stock.FirstOrDefault(a => a.id == c);
                double unitprice = double.Parse(price.Text);
                double totalprice = unitprice * double.Parse(qty.Text);
                double taxper = int.Parse(TextBox1.Text);
                double taxvalue = (taxper / 100) * totalprice;
                double total2 = taxvalue + totalprice;
                DateTime? xdate = null;

                import_items im = new import_items
                {
                    imp_id = int.Parse(impid.Text),
                    prod_code = s.id.ToString(),
                    prod_name = s.name.ToString(),
                    quantity = Math.Round(double.Parse(qty.Text), 4),
                    price = Math.Round(unitprice, 4),
                    total = Math.Round(totalprice, 4),
                    status = 0,
                    ex_date = xdate,

                };
                Mapper.addimportitems(im);

                //code.Text = name.Text = price.Text = qty.Text = "";
                Response.Redirect("newToread.aspx");
            }

        }
    }
    protected void RadioButtonList2_SelectedIndexChanged(object sender, EventArgs e)
    {
        if (RadioButtonList2.SelectedValue == "2")
        {
            DropDownList2.Visible = true;
            var b = db.bank.Where(a => a.roleType == roleType).ToList();
            DropDownList2.DataSource = b;
            DropDownList2.DataValueField = "id";
            DropDownList2.DataTextField = "BankName";
            DropDownList2.DataBind();
        }
        else DropDownList2.Visible = false;
    }
}