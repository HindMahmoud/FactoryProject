<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="addpayment.aspx.cs" Inherits="addpayment" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <style>
        .d {
        width: 146px;
    margin-top: -52px;
    margin-right: 96px;padding:0px}
        </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {
             %>

    <div class="row box box-danger">
        <br />

     <div class="col-md-6">
          البيان:<span class="star-validation">*</span>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="s1" runat="server" ErrorMessage="ادخل البيان" ControlToValidate="name"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox   CssClass="form-control" ID="name" runat="server"></asp:TextBox>
            
        </div>
        <div class="col-md-3">
          القيمه:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="s1" runat="server" ErrorMessage="ادخل القيمة" ControlToValidate="vale"  ForeColor="red"></asp:RequiredFieldValidator>
          <asp:TextBox   CssClass="form-control" ID="vale" runat="server"></asp:TextBox>
            
        </div>
         <div class="col-md-3">
          التاريخ:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="s1" runat="server" ErrorMessage="ادخل التاريخ" ControlToValidate="date"  ForeColor="red"></asp:RequiredFieldValidator>
           <input type="text" runat="server" ClientIDMode="Static"  class="form-control pull-right" ID="date">

     
        </div>
        <div class="col-md-6">
          الملاحظات:
            <asp:TextBox    CssClass="form-control" ID="notes" runat="server"></asp:TextBox>
        </div>
        <div class="col-md-3">
          النوع:<span class="star-validation">*</span>
           <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="s1" runat="server" ErrorMessage="ادخل النوع " ControlToValidate="type"  ForeColor="red"></asp:RequiredFieldValidator>
           <asp:DropDownList    CssClass="form-control" ID="type" runat="server">
                <asp:ListItem></asp:ListItem>
                <asp:ListItem value="0">نثريه</asp:ListItem>
                <asp:ListItem value="1">اساسيه</asp:ListItem>

            </asp:DropDownList>
        </div>
          <div class="col-md-3">
             <br />
             <asp:FileUpload AllowMultiple="true" ID="FileUpload1" runat="server" />
          </div>
       <%-- <div class="col-md-3">
            <br />
            <asp:RadioButtonList ID="RadioButtonList2" runat="server" AutoPostBack="true" RepeatDirection="Horizontal"   OnSelectedIndexChanged="RadioButtonList2_SelectedIndexChanged" >
                                <asp:ListItem  selected="True" Value="1">خزينه</asp:ListItem>
                                <asp:ListItem value="2">بنك</asp:ListItem>
              </asp:RadioButtonList>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" Enabled="false" ValidationGroup="s1" runat="server" ErrorMessage="اختر بنك " ControlToValidate="bankddl"  ForeColor="red"></asp:RequiredFieldValidator>
           <asp:DropDownList  CssClass="form-control d" ID="bankddl" Visible="false"   runat="server">
            </asp:DropDownList>
        </div>--%>
          <div class="col-md-12 text-center">
            <br />
            <asp:Button CssClass="btn btn-primary" OnClick="Button1_Click" ID="Button1" CausesValidation="true"  runat="server" Text="اضافه"  ValidationGroup="s1"/>
        <br />
        <br />
      
          </div>
        </div>

     

    <div class="row" style="overflow-y:auto;height:700px">
        <div class="col-xs-12">
          <div class="box box-danger">
            <div class="box-header">
              <h3 class="box-title"> جميع المصروفات</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="search..">

                </div>
              </div>
            </div>
              <br />
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 
                      DateTime d = DateTime.Now.Date;
                      var x = (from ss in db.payment where ss.roleType==roletype select ss).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th>البيان</th>
                  <th>الملاحظات</th>
                  <th>القيمه</th>
                  <th>النوع</th>
                 <th>التاريخ</th>
                 <th>صوره</th>
                 <th>اسم المستخدم</th>
                  <th></th>
                 
                  <th></th>


                </tr>
                  <% int i = 1; foreach (var item in x)
                      {
                           %> 
                      
                <tr>
                     <td><% Response.Write(i); %></td>

                     <td><% Response.Write(item.title); %></td>
                     <td><% Response.Write(item.notes); %></td>
                     <td><% Response.Write(item.value); %></td>
                     <td><% Response.Write(item.type); %></td>
                 <td><% Response.Write(Convert.ToDateTime(item.date).ToShortDateString()); %></td>
                <%if (item.img != null)
                     { %>
                    <td><a href='photos/<%=item.img %>' target="_blank"><i class="fa fa-file-image-o"></i></a></td>
                    <%}
    else {  %><td></td><%} %>
                     <td><% Response.Write(item.user_name); %></td>
         <td><a  href='addpayment.aspx?id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
        <td><a href="addpayment.aspx?print=<%=item.id %>">  <i class="fa fa-print text-blue"></i></a></td>

                    

                </tr>
                    <%  i++;
                            }
                        }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
          <!-- /.box -->
        </div>
      </div>
    <script>

        function myFunction1() {
            var input, filter, table, tr, td, i;
            input = document.getElementById("search");
            filter = input.value.toUpperCase();
            table = document.getElementById("mytable");
            tr = table.getElementsByTagName("tr");
            for (i = 0; i < tr.length; i++) {
                td = tr[i].getElementsByTagName("td")[1];
                if (td) {
                    if (td.innerHTML.toUpperCase().indexOf(filter) > -1) {
                        tr[i].style.display = "";
                    } else {
                        tr[i].style.display = "none";
                    }
                }
            }
        }
    </script>
   <script>
      
           $('#date').daterangepicker({
               "singleDatePicker": true,
               "showDropdowns": true,
               "timePicker": false,
               "timePickerIncrement": 5,
               "autoApply": true,

               "locale": {
                   "format": "YYYY/MM/DD"

               }
           });
      
</script> 

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

