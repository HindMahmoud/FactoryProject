using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Data.SqlClient;
using System.Data;

public partial class BackupRestore : System.Web.UI.Page
{
    SqlConnection con = new SqlConnection();
    SqlCommand sqlcmd = new SqlCommand();
    SqlDataAdapter da = new SqlDataAdapter();
    DataTable dt = new DataTable();

    protected void Page_Load(object sender, EventArgs e)
    {

    }

    protected void backup_Click(object sender, EventArgs e)
    {
        
            con.ConnectionString = @"Server=.;database=FactoryDB;Integrated Security=true;";

             string backupDIR = "E:\\BackupDB";
             //string backupDIR = Server.MapPath("BackupDB");


            if (!System.IO.Directory.Exists(backupDIR))
            {
                System.IO.Directory.CreateDirectory(backupDIR);
            }
            try
            {
                con.Open();
                sqlcmd = new SqlCommand("backup database FactoryDB to disk='" + backupDIR + "\\" + DateTime.Now.ToString("ddMMyyyy_HHmmss") + ".Bak'", con);
                sqlcmd.ExecuteNonQuery();
                con.Close();
            
            MsgBox("تم بنجاح !", this.Page, this);
        }
            catch 
            {
           
            MsgBox("فشل !", this.Page, this);
        }
        
    }


    protected void restore_Click(object sender, EventArgs e)
    {
        if (FileUpload1.HasFile)

        {
            string file = FileUpload1.FileName;
           //string n= Server.MapPath("BackupDB\\"+file+"");
            string n = "E:\\BackupDB\\" + file + "";
            con.ConnectionString = @"Server=.;database=FactoryDB;Integrated Security=true;";
            try
            {
                con.Open();
                SqlCommand command = con.CreateCommand();

            command.CommandText = "USE [master] ";
            command.ExecuteNonQuery();
            command.CommandText = "ALTER DATABASE [FactoryDB] SET Single_User WITH Rollback Immediate ";
            command.ExecuteNonQuery();
                command.CommandText = " RESTORE DATABASE FactoryDB FROM DISK = '" + n+ "' WITH REPLACE ";
                command.ExecuteNonQuery();

            command.CommandText = "ALTER DATABASE [FactoryDB] SET Multi_User ";
            command.ExecuteNonQuery();

                MsgBox("تم بنجاح !", this.Page, this);
            }
            catch (Exception)
            {
                MsgBox("error !", this.Page, this);

                //SELECT request_session_id FROM sys.dm_tran_locks
                //WHERE resource_database_id = DB_ID('YourDatabase')
                // KILL spid
                //USE Master
                //ALTER DATABASE YourDatabase SET MULTI_USER
            }
            finally
            {
                con.Dispose();
                con.Close();
            }
        }
        else { MsgBox("حدد الملف !", this.Page, this); }
    }
    public void MsgBox(String ex, Page pg, Object obj)
    {
        string s = "<SCRIPT language='javascript'>alert('" + ex.Replace("\r\n", "\\n").Replace("'", "") + "'); </SCRIPT>";
        Type cstype = obj.GetType();
        ClientScriptManager cs = pg.ClientScript;
        cs.RegisterClientScriptBlock(cstype, s, s.ToString());
    }
}