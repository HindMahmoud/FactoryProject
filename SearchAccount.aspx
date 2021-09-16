<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="SearchAccount.aspx.cs" Inherits="SearchAccount" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>


     <div class="col-md-12 box-body bg-info">
        <h3>اليوم</h3>
        <div class="col-md-3">
        <br />
        <asp:Button ID="btn1" OnClick="btn1_Click" CssClass="btn btn-flat btn-lg bg-aqua-gradient center-block"  runat="server" Text="بحث حركه خزن و بنك" />
        </div>
         <%--<div class="col-md-3">
        <br />
        <asp:Button ID="bt2" OnClick="bt2_Click" CssClass="btn btn-flat btn-lg bg-green-gradient center-block"  runat="server" Text="بحث ايرادات" />
        </div>--%>
         <div class="col-md-3">
        <br />
        <asp:Button ID="btn3" OnClick="btn3_Click" CssClass="btn btn-flat btn-lg bg-red-gradient center-block"  runat="server" Text="بحث مصروفات" />
        </div>

        </div>

    <br />
    <br />
    <div class="col-md-12 box-body bg-gray" style="margin-top:20px">
         
           <div class="col-md-6">
                <label for="middle-name" class="control-label no-print">من :</label>
                    <asp:TextBox ID="fromm" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
           
            </div>
                    <div class="col-md-6">
                <label for="middle-name" class="control-label no-print">الي :</label>
                    <asp:TextBox ID="too" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
           
            </div>
            <div class="col-md-12"></div>
            
           <div class="col-md-6">
        <br />
        <asp:Button ID="btn4" OnClick="btn4_Click" CssClass="btn btn-flat btn-lg bg-aqua-gradient center-block"  runat="server" Text="بحث حركه خزن و بنك" />
        </div>
           <div class="col-md-6">
        <br />
        <asp:Button ID="btn6" OnClick="btn6_Click" CssClass="btn btn-flat btn-lg bg-red-gradient center-block"  runat="server" Text="بحث مصروفات" />
        </div>
           </div>
    <div class="col-md-12 box-body bg-gray">
         <div class="col-md-6">
        <br />
        <asp:Button ID="Button1" OnClick="Button1_Click" CssClass="btn btn-flat btn-lg bg-yellow-gradient center-block"  runat="server" Text="بحث حســـــابات عملاء" />
        </div>
         <div class="col-md-6">
        <br />
        <asp:Button ID="Button2" OnClick="Button2_Click" CssClass="btn btn-flat btn-lg bg-lime center-block"  runat="server" Text="بحث حســـــابات موردين" />
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

