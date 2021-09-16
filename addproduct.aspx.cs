using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class addproduct : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "",username="";
    public static int uid = 0;

    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();

        }
        if (Session["uid"] != null && Session["name"] != null)
        {
            username = Session["name"].ToString();
            uid = int.Parse(Session["uid"].ToString());
        }
        else Response.Redirect("login.aspx");
        if (!IsPostBack)
        {
            var t = db.category.Where(a => a.roleType == roleType).ToList();
            main_it.DataSource = t;
            main_it.DataValueField = "id";
            main_it.DataTextField = "name";
            main_it.DataBind();
            main_it.Items.Insert(0, String.Empty);
            
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
            {
                int x = int.Parse(Request.QueryString["id"].ToString());
                stock f = db.stock.FirstOrDefault(a => a.id == x);
                db.stock.Remove(f);
                db.SaveChanges();

                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["cat_id"])))
                {
                    int h= int.Parse(Request.QueryString["cat_id"].ToString());

                    Response.Redirect("addproduct.aspx?cat_id="+h);
                }
                else
                {
                    Response.Redirect("addproduct.aspx"); }

            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["editid"])))
            {
                int x = int.Parse(Request.QueryString["editid"].ToString());
                stock f = db.stock.FirstOrDefault(a => a.id == x);
                divOpen.Visible = false;
                var itt = db.stock.FirstOrDefault(a => a.id == f.id);
                if (itt != null)
                {
                    main_it.SelectedValue = f.cat_id.ToString();
                }
                price.Text = f.price.ToString();
                bprice.Text = f.buy_price.ToString();

                code.Text = f.code.ToString();
                if (f.size != null)
                {
                    ssize.Text = f.size.ToString();
                }
                aler.Text = f.min_quantity.ToString();
                first_qty.Text = f.quantity.ToString();
                //edit percentage of halek in stock destroy table
                halek.Text = f.perc_destroy.ToString();
                Button1.Text = "تعديل";
            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["print"])))
            {
               
                int x = int.Parse(Request.QueryString["print"].ToString());
                stock f = db.stock.FirstOrDefault(a => a.id == x);
                string q = @"select  * from stock where id=" + x + " ";
                string cr = "bar.rpt";
                Session["query"] = q;
                Session["cr"] = cr;

                Response.Redirect("report.aspx");

            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        if (Button1.Text == "تعديل")
        {
            int t = int.Parse(Request.QueryString["editid"].ToString());
  
            if (db.stock.Any(a => a.code == code.Text && a.id != t))
                {
                    { MsgBox("ادخل كود اخر ", this.Page, this); }
                }
                else
                {   stock f = db.stock.FirstOrDefault(a => a.id == t);
                    stock_destroy d = db.stock_destroy.FirstOrDefault(a => a.id_item == f.id);
                    string nn = main_it.SelectedItem.ToString() + " " + ssize.Text;
                    f.name = nn;
                    f.code = code.Text;
                    f.buy_price = double.Parse(bprice.Text);
                    f.price = double.Parse(price.Text);
                    f.min_quantity = double.Parse(aler.Text);
                    if (f.size != null)
                    {
                        f.size = ssize.Text;
                    }
                f.perc_destroy = float.Parse(halek.Text);
                db.SaveChanges();
                //var p = db.stock_destroy.Where(a => a.typeRole == roleType && a.id_item == f.id).FirstOrDefault();
                //if (p != null) {
                //    p.quantity = (f.quantity - f.perc_destroy / 100 * f.quantity);
                //    db.SaveChanges();
                //}
                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["cat_id"])))
                    {
                        int h = int.Parse(Request.QueryString["cat_id"].ToString());
                        Response.Redirect("addproduct.aspx?cat_id=" + h);
                    }
                    else
                    {
                        Response.Redirect("addproduct.aspx");
                    }

               
            }
        }
        else {
          
        if (db.stock.Any(a => a.code == code.Text))
                {
                    { MsgBox("ادخل كود اخر ", this.Page, this); }
                }
                else
                {

                    int? cat; string cat_n = null;
                    if (main_it.SelectedValue!="")
                    {
                        cat = int.Parse(main_it.SelectedValue.ToString());
                        var n = (from g in db.category where g.id == cat select g.name).FirstOrDefault();
                        cat_n = n.ToString();
                    }
                    else { cat = 0; cat_n = null; }

                    string nn = main_it.SelectedItem.ToString() + " " + ssize.Text;
                stock s = new stock
                {
                    name = nn,
                    price = double.Parse(price.Text),
                    buy_price = double.Parse(bprice.Text),
                    code = code.Text,
                    min_quantity = double.Parse(aler.Text),
                    quantity = double.Parse(first_qty.Text),
                    cat_id = cat,
                    cat_name = cat_n,
                    roleType = roleType,
                    size = ssize.Text,
                    perc_destroy=float.Parse(halek.Text)
                        
                    };
                    Mapper.addmed(s);
                double halekperc = 0;
                if (halek.Text != "") halekperc = double.Parse(halek.Text);
                stock_destroy dd = new stock_destroy
                {
                    date = DateTime.Now,
                    typeRole = roleType,
                  
                    id_item = s.id,
                    product_id = int.Parse(s.code),
                    product_name = s.name,
                    user_id = uid,
                    user_name = username,
                    quantity=0//(s.quantity-s.perc_destroy/100*s.quantity),
                };
                db.stock_destroy.Add(dd);
                db.SaveChanges();
                if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["cat_id"])))
                    {
                        int h = int.Parse(Request.QueryString["cat_id"].ToString());

                        Response.Redirect("addproduct.aspx?cat_id=" + h);
                    }
                    else
                    {
                        Response.Redirect("addproduct.aspx");
                    }

               
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

    protected void show_Click(object sender, EventArgs e)
    {
        string q = @"select * from stock where roleType='"+roleType+"'";
        string cr = "MainStockR.rpt";
        Session["query"] = q;
        Session["cr"] = cr;
        Response.Redirect("report.aspx");
    }

}