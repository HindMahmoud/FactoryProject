<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="MoneyConvert.aspx.cs" Inherits="MoneyConvert" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
  <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            { %>
      <div class="row">

         <div class="col-md-6 col-xs-12">
        <div class="small-box bg-aqua-gradient">
            <div class="inner">
                <% FactoryDBEntities db = new FactoryDBEntities();
                     var g = (from ss in db.savee where ss.roleType==roleType   select ss).Distinct().ToList();
                    double max_value = 0;
                    if (g != null)
                    {
                         max_value = double.Parse((g.Sum(a=>a.daan)-g.Sum(a=>a.mdeen)).ToString());

                    }
                     %>
              <h3><% Response.Write(max_value); %></h3>
              <p>رصيد الخزنه</p>
            </div>
            <div class="icon">
              <i class="ion ion-cash"></i>
            </div>
           
            </div>
            </div>


         <div class="col-md-6 col-xs-12">
        <div class="small-box bg-green-gradient">
            <div class="inner">
              <%  var most = (from s in db.bank_account where s.typeRole == roleType group s by new { s.bank_id,s.bank_name } into gf select new { n = gf.Key.bank_id,gf.Key.bank_name, mdenSum = gf.Sum(a => a.mdeen) ,daansum=gf.Sum(a=>a.daan)}).ToList();
                double? max_value2 = 0;
                    if (most != null)
                    { double? totalDan = 0;
                        double? totalmdeen = 0;
                        foreach (var r in most)
                        {
                            totalDan += r.daansum;
                            totalmdeen += r.mdenSum;
                        }
                        max_value2 = (totalDan - totalmdeen);
                    }
                   %>  
              <h3><% Response.Write(max_value2); %></h3>

              <p>رصيد البنك</p>
            </div>
            <div class="icon">
              <i class="fa fa-dollar"></i>
            </div>
           
            </div>
            </div>
          <br />
        <div class="col-md-4">
            اختر البنك:<span class="star-validation">*</span>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="s1" runat="server" ErrorMessage="اختر الاسم" ControlToValidate="bankddl"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control js-example-placeholder-single"  ID="bankddl" runat="server"  > 
            </asp:DropDownList>
        </div>
        <div class="col-md-4">
            المبلغ:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="s1" runat="server" ErrorMessage="ادخل القيمه" ControlToValidate="value"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox ID="value" TextMode="Number" CssClass="form-control" runat="server"></asp:TextBox>

        </div>
         <div class="col-md-4">
            <br />
            <asp:Button ID="btn_add" OnClick="btn_add_Click" CssClass="btn btn-primary" runat="server" Text="تحويل"/>
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

