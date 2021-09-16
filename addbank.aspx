<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="addbank.aspx.cs" Inherits="addbank" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
 <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {
             %>

    <div class="row box box-success">
        <br />

     <div class="col-md-6">
          اسم البنك:<span class="star-validation">*</span>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="s1" runat="server" ErrorMessage="ادخل الاسم" ControlToValidate="name"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox   CssClass="form-control" ID="name" runat="server"></asp:TextBox>
            
        </div>
        <div class="col-md-3">
          الرصيد الافتتاحي:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="s1" runat="server" ErrorMessage="ادخل القيمة" ControlToValidate="vale"  ForeColor="red"></asp:RequiredFieldValidator>
          <asp:TextBox  TextMode="Number"   CssClass="form-control"  ID="vale" runat="server"></asp:TextBox>
            
        </div>
     
          <div class="col-md-12 text-center">
            <br />
            <asp:Button CssClass="btn btn-primary" OnClick="Button1_Click" ID="Button1" CausesValidation="true"  runat="server" Text="اضافه"  ValidationGroup="s1"/>
        <br />
        <br />
      
          </div>
        </div>

     

    <div class="row" style="overflow-y:auto;height:700px">
        <div class="col-xs-12">
          <div class="box box-success">
            <div class="box-header">
              <h3 class="box-title">  البنوك</h3>

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
                      var x = (from ss in db.bank where ss.roleType==roletype select ss).ToList();
                      if (x != null)
                      {
                       %>
                <tr>
                  
                    <th>#</th>
                  <th >اسم البنك</th>
                  <th>الرصيد </th>
                  <th>اسم المستخدم</th>
                  <th></th>
                 
                  <th></th>


                </tr>
                  <% int i = 1; foreach (var item in x)
                      { var usname = db.users.Where(u => u.id ==item.user_id).FirstOrDefault();
                           %> 
                      
                <tr>
                     <td><% Response.Write(i); %></td>
                     <td><a  href="profilebank.aspx?id=<%=item.id %>"><% Response.Write(item.BankName); %></a></td>
                     <td><% Response.Write(item.value); %></td>
                     <td><%=usname.name %></td> 
                    <td><a  href='addbank.aspx?id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
                     <td><a href="addbank.aspx?edit=<%=item.id %>">  <i class="fa fa-edit text-blue"></i></a></td>
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


