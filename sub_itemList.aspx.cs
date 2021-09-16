using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class sub_itemList : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    public static string roleType = "";
    protected void Page_Load(object sender, EventArgs e)
    {
        if (Session["roleType"] != null)
        {
            roleType = Session["roleType"].ToString();
        }
        if (!IsPostBack)
        {
    
            if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["del"])))
            {int x = int.Parse(Request.QueryString["del"].ToString());
                var t = (from ii in db.category where ii.id == x select ii).ToList();
                db.category.RemoveRange(t);
                db.SaveChanges();
               
                Response.Redirect("sub_itemList.aspx");

            }
            else if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["editid"])))
            {
                int x = int.Parse(Request.QueryString["editid"].ToString());
                var f = db.category.FirstOrDefault(a => a.id == x);
                name.Text = f.name.ToString();
              
                add.Text = "تعديل";


            }
        }
    }
  
    protected void add_Click(object sender, EventArgs e)
    {
        int x_id = 0;
        if (add.Text == "تعديل")
        {
            int t = int.Parse(Request.QueryString["editid"].ToString());
            var f = db.category.FirstOrDefault(a => a.id == t);
            f.name = name.Text;
           db.SaveChanges();
           
        }
        else {
            category ss = new category
            {
                roleType=roleType,
                name=name.Text
                
            };
            db.category.Add(ss);
            db.SaveChanges();
            
        }

        Response.Redirect("sub_itemList.aspx?id=" + x_id);
    }
    }
