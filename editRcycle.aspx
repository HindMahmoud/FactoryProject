<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="editRcycle.aspx.cs" Inherits="editRcycle" %>

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
    
     <asp:Label Visible="false" ID="invid" runat="server" Text=""></asp:Label>
    <div class="row box box-success">
        <br />

     <div class="col-md-6">
         اسم الصنف :<span class="star-validation">*</span>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="s1" runat="server" ErrorMessage="ادخل الاسم" ControlToValidate="main_it"  ForeColor="red"></asp:RequiredFieldValidator>
            <asp:DropDownList AppendDataBoundItems="true" AutoPostBack="true" OnSelectedIndexChanged="main_it_SelectedIndexChanged" CssClass="form-control js-example-placeholder-single"  ID="main_it" runat="server"  > 
            </asp:DropDownList>
            
        </div>
        <div class="col-md-3">
           الكمية:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="s1" runat="server" ErrorMessage="ادخل الكمية" ControlToValidate="quan"  ForeColor="red"></asp:RequiredFieldValidator>
          <asp:TextBox    CssClass="form-control"  ID="quan" runat="server"></asp:TextBox>
        </div>
     <div class="col-md-3">
           سعر شراء الوحدة:<span class="star-validation">*</span>
            <asp:RequiredFieldValidator ID="RequiredFieldValidator5" ValidationGroup="s1" runat="server" ErrorMessage="ادخل السعر" ControlToValidate="buyPrice"  ForeColor="red"></asp:RequiredFieldValidator>
          <asp:TextBox   ReadOnly="true" Text="0"  CssClass="form-control"  ID="buyPrice" runat="server"></asp:TextBox>
        </div>
          <div class="col-md-12 text-center">
            <br />
            <asp:Button CssClass="btn btn-primary" OnClick="Button1_Click1" ID="Button1" CausesValidation="true"  runat="server" Text="اضافه"  ValidationGroup="s1"/>
        <br />
        <br />
      
          </div>
        </div>

      <section class="invoice">
    
      
      <!-- Table row -->
      <div class="row">
           <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره اعادة تصنيع:#<%=invid.Text %>
            <small class="pull-left">بتاريخ: <%=DateTime.Now %></small>
          </h2>
        </div>
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% 
       FactoryDBEntities db = new FactoryDBEntities();
    var x = (from s in db.destroy_inv where s.roleType==roleType select s).OrderBy(a=>a.prod_name).ToList();
       %>
            <thead>
               
            <tr>
              <th>#</th>
              <th>الصنف الهالك</th>
              <th>الكمية #</th>
              <th>الاجمالي #</th>
              <th></th>
              <th></th>
            </tr>
               
            </thead>
            <tbody>
                 <%if (x != null)
                     {
                         int i = 1;
                         float c = 0;
                         foreach (var item in x) {
                             var t = db.stock.Where(a => a.roleType == roleType && a.id == item.id).FirstOrDefault();
                             if (t != null) {
                                 c = float.Parse(t.code);
                   }%>
            <tr>
              <td><%=i %></td>
              <td><%=item.prod_name %></td>
              <td><%=item.quant %></td>
              <td><%=item.item_total %></td>
             <td> <a href="editRcycle.aspx?delitem=<%=item.id %>&&edit=<%=item.inv_id%>">  <i class="fa fa-trash-o text-red"></i></a></td>
            </tr>
                 <%i++;
                         }
                     } %>
            </tbody>
          </table>
        </div>
        <!-- /.col -->
      </div>
      <!-- /.row -->
        
      <div class="row">
          <hr style="border:1px solid gray"/> 
          <div class="col-xs-12">
             <div class="table-responsive">
                 <!--Table running price and total of invoice----->
                  <table class="table">
              
              <tr>
                <td >الاجمالي :<asp:RequiredFieldValidator ID="RequiredFieldValidator6" ValidationGroup="s2" runat="server" ErrorMessage="ادخل الاجمالي" ControlToValidate="invoice_total"  ForeColor="red"></asp:RequiredFieldValidator>
                <asp:TextBox  Text="0" Width="50%"   CssClass="form-control" ID="invoice_total" runat="server"></asp:TextBox></td>
              <td></td>
                   </tr>

               <tr>
                <td>سعر التشغيل: <asp:RequiredFieldValidator ID="RequiredFieldValidator7" ValidationGroup="s2" runat="server" ErrorMessage="ادخل سعر التشغيل" ControlToValidate="run_pricetxt"  ForeColor="red"></asp:RequiredFieldValidator>
                <asp:TextBox Width="50%"  Text="0"  CssClass="form-control" ID="run_pricetxt" runat="server"></asp:TextBox></td>
              <td></td>
               </tr>
            </table>

            <table class="table">
              
              <tr>
                <th >اعادة تصنيع:</th>
                <td><asp:RequiredFieldValidator ID="RequiredFieldValidator2" ValidationGroup="s2" runat="server" ErrorMessage="ادخل الصنف" ControlToValidate="DropDownList1"  ForeColor="red"></asp:RequiredFieldValidator>
                    <asp:DropDownList AppendDataBoundItems="true" CssClass="form-control js-example-placeholder-single"  ID="DropDownList1" runat="server"  > 
                    </asp:DropDownList></td>

               
                <th>الكمية: <asp:RequiredFieldValidator ID="RequiredFieldValidator4" ValidationGroup="s2" runat="server" ErrorMessage="ادخل الكمية" ControlToValidate="qty"  ForeColor="red"></asp:RequiredFieldValidator>
        </th>
                <td>
                      <asp:TextBox  Text="0"  CssClass="form-control" ID="qty" runat="server"></asp:TextBox></td>
                <td></td>
              </tr>
            </table>
          </div>
        </div>
          <div class="col-md-6"> 
         <div class="row no-print">
        <div class="col-xs-12">
            <asp:button runat="server" ValidationGroup="s2" ID="btn_addImport" Text="حفظ" OnClick="Button1_Click" cssclass="center-block btn btn-primary pull-right" /> 
          
        
        </div>
      </div>
              </div>
        </div>

      <!-- this row will not appear when printing -->
     
    </section>

   
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




