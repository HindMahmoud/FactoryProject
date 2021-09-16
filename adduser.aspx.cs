using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class adduser : System.Web.UI.Page
{
    FactoryDBEntities db = new FactoryDBEntities();
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!IsPostBack)
        {
            //var xx = (from i in db.setting select i.taxes).FirstOrDefault();
            //if (xx != null)
            //{
            //    extraper.Text = xx.ToString();
            //}
            //else { extraper.Text = "0"; }
            //var xx2 = (from i in db.setting select i.dis).FirstOrDefault();
            //if (xx2 != null)
            //{
            //    TextBox1.Text = xx2.ToString();
            //}
            //else { TextBox1.Text = "0"; }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {  if (db.users.Any(a => a.name == name.Text))
            {
            Response.Write("<script>alert('ادخل اسم مستخدم اخر')</script>");
            }
            else {
            users emp = new users
            {
                name = n.Text,
                user_name = name.Text,
                password = password.Text,
                role = role.SelectedItem.ToString(),
                typeRole = ddl.SelectedValue.ToString()
                };

                Mapper.adduser(emp);

                Response.Redirect("adduser.aspx");
            }
  
    }
  
    protected void taxes_Click(object sender, EventArgs e)
    {
        //if(extraper.Text !=""&&TextBox1.Text!="")
        //{
        //    double per = double.Parse(extraper.Text);
        //    double per2 = double.Parse(TextBox1.Text);

        //    var xx = (from i in db.setting select i).FirstOrDefault();
        //    xx.taxes = per;
        //    xx.dis = per2;

        //    db.SaveChanges();
        //    Response.Redirect("adduser.aspx");

        //}
        //else {
        //    Response.Write("<script>alert('النسبه غير صحيحه !')</script>");
        //    }
    }
}