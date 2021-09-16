using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

public partial class login : System.Web.UI.Page
{
    static FactoryDBEntities ecco = new FactoryDBEntities();
    protected void Page_Load(object sender, EventArgs e)
    {
        Session.Clear();
        if (!IsPostBack)
        {
            if (Request.Cookies["UserName"] != null && Request.Cookies["Password"] != null)
            {
                TextBox1.Text = Request.Cookies["UserName"].Value;
                TextBox2.Attributes["value"] = Request.Cookies["Password"].Value;
            }
        }
    }

    protected void Button1_Click(object sender, EventArgs e)
    {
        //DateTime today = DateTime.Now;
        //DateTime day30 = new DateTime(30, 5, 2018);
        //if (today <= day30)
        //{
            if (TextBox1.Text == "")
            {
                MsgBox("ادخل اسم المستخدم !", this.Page, this);
            }
            else if (TextBox2.Text == "")
            {
                MsgBox("ادخل الرقم السري !", this.Page, this);
            }

            else
            {
            if (ecco.users.Any(a => a.user_name == TextBox1.Text)/*|| ecco.pr.Any(a => a.user_name == TextBox1.Text)*/)
                {
                    var f = (from ss in ecco.users where ss.user_name == TextBox1.Text select ss.password).FirstOrDefault();
                    //  var ff = (from ss in ecco.pr where ss.user_name == TextBox1.Text select ss.password).FirstOrDefault();
                    string x, xx;
                    if (f == null)
                    {
                        x = "";
                    }
                    else
                    {
                        x = f.ToString();
                    }
                    
                    if (x == TextBox2.Text)
                    {
                        Session["name"] = TextBox1.Text;
                   
                    users u = ecco.users.FirstOrDefault(r => r.user_name == TextBox1.Text);
                    Session["uid"] = u.id;
                   Session["role"] = u.role;
                    Session["roleType"] = u.typeRole;
                        Response.Redirect("Indexpage.aspx");

                    }
                    else { MsgBox("الرقم السري غير صحيح !", this.Page, this); }
                }
                else { MsgBox("اسم المستخدم غير صحيح !", this.Page, this); }
            }
            //if (CheckBox1.Checked)
            //{
            //    Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(30);
            //    Response.Cookies["Password"].Expires = DateTime.Now.AddDays(30);
            //}
            //else
            //{
            //    Response.Cookies["UserName"].Expires = DateTime.Now.AddDays(-1);
            //    Response.Cookies["Password"].Expires = DateTime.Now.AddDays(-1);

            //}
            //Response.Cookies["UserName"].Value = TextBox1.Text.Trim();
            //Response.Cookies["Password"].Value = TextBox2.Text.Trim();
        //}
        //else
        //{
        //    MsgBox("licence expired", this.Page, this);
        //}
       
    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }
}