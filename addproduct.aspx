<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="addproduct.aspx.cs" Inherits="addproduct" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript">

         $(function () {
             initdropdown();
         })
         function initdropdown() {
            $(".js-example-placeholder-single").select2({
                placeholder: "...اختار",
                allowClear: true
            });
        };
    </script>
   
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    <div class="row">
           
        <div class="col-md-3">
            الصنف الرئيسي:
            <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control js-example-placeholder-single" ID="main_it" runat="server"  >
                <asp:ListItem></asp:ListItem>
            </asp:DropDownList>
        </div>
       
        <div class="col-md-2">
            المقاس:
            <asp:TextBox  Text="1" CssClass="form-control" ID="ssize" runat="server"></asp:TextBox>
        </div>
         
        
        <div class="col-md-3">
             <asp:RegularExpressionValidator CssClass="text-red" ID="RegularExpressionValidator1"
                ControlToValidate="code" runat="server"
                ErrorMessage="ارقام فقط" 
                ValidationExpression="^[0-9]\d{0,9}(\.\d{1,3})?%?$">
             </asp:RegularExpressionValidator>
            الكود:<span class="star-validation">*</span>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="er" runat="server" ErrorMessage="ادخل الكود  " ControlToValidate="code"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox  CssClass="form-control" ID="code" runat="server"></asp:TextBox>
             
        </div>
       
        <div id="divOpen" runat="server"  class="col-md-3">
            رصيد افتتاحي :<span class="star-validation">*</span>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ValidationGroup="er" ErrorMessage="ادخل الرصيد الافتتاحي " ControlToValidate="first_qty"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox  CssClass="form-control" ID="first_qty" AutoCompleteType="Disabled" Text="0" runat="server"></asp:TextBox>
        </div>
        
        <div class="col-md-3">
            كميه التنبيه:<span class="star-validation">*</span>
           <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ValidationGroup="er" ErrorMessage="ادخل كمية التنبيه  " ControlToValidate="aler"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox  CssClass="form-control" ID="aler" AutoCompleteType="Disabled" Text="0" runat="server"></asp:TextBox>
        </div>
        <div class="col-md-3">
            سعر الشراء للقطعه:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ValidationGroup="er" ErrorMessage="ادخل سعر الشراء   " ControlToValidate="bprice"  ForeColor="red"></asp:RequiredFieldValidator>
           <asp:TextBox  CssClass="form-control" ID="bprice" AutoCompleteType="Disabled" runat="server"></asp:TextBox>
        </div>
        <div class="col-md-3">
            سعر البيع للقطعه:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ValidationGroup="er" ErrorMessage="ادخل سعر البيع   " ControlToValidate="price"  ForeColor="red"></asp:RequiredFieldValidator>
           <asp:TextBox  CssClass="form-control" ID="price" AutoCompleteType="Disabled" runat="server"></asp:TextBox>
        </div>
        <div class="col-md-3">
            نسبة الهالك:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator6" runat="server" ValidationGroup="er" ErrorMessage="ادخل نسبة الهالك" ControlToValidate="halek"  ForeColor="red"></asp:RequiredFieldValidator>
           <asp:TextBox  Text="0" CssClass="form-control" ID="halek" AutoCompleteType="Disabled" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-12 text-center">
            <br />
            <asp:Button CssClass="btn btn-primary" OnClick="Button1_Click" ValidationGroup="er" ID="Button1" runat="server" Text="اضافه" />
            
        </div>
       
    </div>
     <br />

    <div class="row">
        <div class="col-xs-12">
          <div class="box">
            <div class="box-header">
              <h3 class="box-title">الاصناف</h3>
                <asp:Button ID="show" OnClick="show_Click" runat="server" Text="عرض"  CssClass=" btn btn-success" Style="margin-right:20px"/>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="بحث باسم الصنف..">

                </div>
              </div>
            </div>
              <br />
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 
                      FactoryDBEntities db = new FactoryDBEntities();
                      DateTime d = DateTime.Now.Date;
                      var x=(from ss in db.stock select ss).ToList();
               if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["cat_id"])))
                {
                    int h = int.Parse(Request.QueryString["cat_id"].ToString());

                    x= (from ss in db.stock where ss.cat_id==h&&ss.roleType==roleType select ss).ToList();
                }
                else
                {
                    x= (from ss in db.stock where ss.roleType==roleType select ss).OrderBy(a=>a.name).ToList();
                }

                     
                      if (x != null)
                      {
                       %>
             <tr class="bg-gray-active">

                    <th>#</th>
                    <th>الكود</th>

                  <th>الاسم</th>
                  <th>عدد القطع </th>
                 <th>كميه التنبيه</th>
                  <th>سعر الشراء</th>
                  <th>سعر البيع</th>
                 <th>نسبة الهالك </th>
                  <th></th>
                 <th></th>
                 <th></th>

                </tr>
                  <% int i = 1; foreach (var item in x)
                      {
                          double? perc = 0;
                         
                          double diee =double.Parse(item.quantity.ToString());
                          double numqty = 0;
                          if(diee==0)
                          {
                              numqty = 0;
                          }
                          else
                          {
                              numqty = diee ;
                          }

                           %> 
                      
                <tr>
                 <td ><% Response.Write(i); %></td>
                 <td><% Response.Write(item.code); %></td>
                 <td><% Response.Write(item.name); %></td>
                  <td><% Response.Write(item.quantity); %></td>
                  <td><% Response.Write(item.min_quantity); %></td>
                  <td><% Response.Write(item.buy_price); %></td>
                  <td><% Response.Write(item.price); %></td>
<td><% Response.Write(item.perc_destroy); %></td>
                
                 <% if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["cat_id"])))
                {
                    int h = int.Parse(Request.QueryString["cat_id"].ToString());
                         %>
                     <td><a  href='addproduct.aspx?cat_id=<%=h %>&&editid=<%=item.id %>'>  <i class="fa fa-edit text-aqua"></i></a></td>
                    
                   <td><a  href='addproduct.aspx?cat_id=<%=h %>&&id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>

                    <%
                  
                }
                else
                {
                   %>
                    <td><a  href='addproduct.aspx?editid=<%=item.id %>'>  <i class="fa fa-edit text-aqua"></i></a></td>
                    
                   <td><a  href='addproduct.aspx?id=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>

                    <%
                } %>
                   <td><a  href='addproduct.aspx?print=<%=item.id %>'>  <i class="fa fa-print text-blue"></i></a></td>
                   

                    

                </tr>
                    <% i++; }
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

