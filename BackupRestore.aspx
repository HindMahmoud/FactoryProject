<%@ Page Title="" Language="C#" MasterPageFile="~/home.master" AutoEventWireup="true" CodeFile="BackupRestore.aspx.cs" Inherits="BackupRestore" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
<div class="row">
        <div class="col-md-2">
             <asp:Button CssClass="btn btn-default bg-blue-gradient" ID="backup" runat="server" Text="نسخ" OnClick="backup_Click" />
       </div >
         <div class="col-md-10">
             <span  class=" bg-blue-gradient"> Take a backup of your database posted in "BackupDB" folder </span>
             </div>
    </div>
        <br />
     <div class="row">
         <div class="col-md-1">
    <asp:Button CssClass="btn btn-default bg-blue-gradient" ID="restore" runat="server" Text="استرجاع" OnClick="restore_Click" />
             </div >
         <div class="col-md-4"><asp:FileUpload CssClass="btn btn-default" AllowMultiple="true" ID="FileUpload1" runat="server" /></div>
         <div class="col-md-7">
             <span  class=" bg-blue-gradient">Select a backup of your database from  "BackupDB" folder  </span>
             </div>
</div>
<% }
           else
           {
               %><div   style="font-weight:bold"  class="text-center text-danger">ليس لديك صلاحيه لدخول الصفحه</div><%
           }
       }

       else
       {
           Response.Redirect("login.aspx");
       }%>
</asp:Content>

