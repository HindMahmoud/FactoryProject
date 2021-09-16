<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="ReturnsInvoice.aspx.cs" Inherits="ReturnsInvoice" %>


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

    <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>


     <asp:Label Visible="false" ID="impid" runat="server" Text=""></asp:Label>
    
    <div class="row box box-warning">

        <asp:UpdatePanel runat="server" id="UpdatePanel" updatemode="Conditional">
<ContentTemplate>
    <script>
        Sys.Application.add_load(initdropdown);
       

        </script>
     <div class="col-md-3">
         رقم الفاتوره:
         <asp:TextBox OnTextChanged="inv_id_TextChanged" CssClass="form-control" AutoPostBack="true"  ID="inv_id" runat="server"></asp:TextBox>

     </div>
    <div class="col-md-3">
        الاصناف: <span class="star-validation">*</span>
   <asp:DropDownList ID="items" ToolTip="select" AutoPostBack="true" OnSelectedIndexChanged="items_SelectedIndexChanged" CssClass="form-control js-example-placeholder-single select2" runat="server">
       <asp:ListItem></asp:ListItem>
   </asp:DropDownList>

          </div>
    
  <div class="col-md-12"></div>
    

      <div class="col-md-3">
         الكميه :<span class="star-validation">*</span>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator3" ValidationGroup="s1" runat="server" ErrorMessage="ادخل الكمية" ControlToValidate="qty"  ForeColor="red"></asp:RequiredFieldValidator>
          
         <asp:TextBox CssClass="form-control"   ID="qty" runat="server" ></asp:TextBox>

     </div>

      <div class="col-md-3">
         سعر الوحده:<span class="star-validation">*</span>
          <asp:RequiredFieldValidator ID="RequiredFieldValidator1" ValidationGroup="s1" runat="server" ErrorMessage="ادخل السعر" ControlToValidate="price"  ForeColor="red"></asp:RequiredFieldValidator>
          
         <asp:TextBox CssClass="form-control"   ID="price" runat="server"></asp:TextBox>

     </div>
     </ContentTemplate>
   </asp:UpdatePanel>
       
         <div class="col-md-12 text-center">
            <br />
            <asp:Button OnClick="Button1_Click"  CssClass="btn btn-primary" ValidationGroup="s1" ID="Button1" runat="server" Text="اضافه" Style="margin-right:5px" />
             <br />
             <br />
        </div>

    </div>

    <section class="invoice">
      <!-- title row -->
      <div class="row">
        <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره مرتجع:#<%=impid.Text %>
            <small class="pull-left">بتاريخ: <%=DateTime.Now.ToShortDateString() %></small>
          </h2>
        </div>
        <!-- /.col -->
      </div>
      <!-- info row -->
    

      <!-- Table row -->
      <div class="row">
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% 
    FactoryDBEntities db = new  FactoryDBEntities();
    int imp_id = int.Parse(impid.Text);
    var x = (from s in db.return_items where s.return_id == imp_id select s).ToList();


                   %>
            <thead>
               
            <tr>
              <th>#</th>
              <th>الصنف</th>
              <th>الكود #</th>
              <th>الكميه</th>
              <th>اجمالي السعر</th>
             
              <th></th>
              <th></th>



            </tr>
               
            </thead>
            <tbody>
                 <%if (x != null)
                     {
                         foreach (var item in x) { %>
            <tr>
              <td><%=item.id %></td>
              <td><%=item.prod_name %></td>
              <td><%=item.prod_code %></td>
              <td><%=item.quantity %></td>
              <td><%=item.total %></td>

         <td><a href="ReturnsInvoice.aspx?delitem=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>

                
    


            </tr>
                 <%}
                     } %>
            </tbody>
          </table>
        </div>
        <!-- /.col -->
      </div>
      <!-- /.row -->
        
      <div class="row">
       <div class="col-xs-6">
          <p class="lead">اجمالي المرتجع:</p>
              <% var sum = (from s in db.return_items where s.status == 0 && s.return_id == imp_id select s.total).Sum(); %>
        <div class="table-responsive">
            <table class="table">
              <tr>
                <th style="width:50%">المبلغ:</th>
                <td>$<%=sum %></td>
                  <th>سداد </th>
                <td><asp:TextBox runat="server" id="payed" ></asp:TextBox></td>
              </tr>
             
            </table>
          </div>
        </div>

        <!-- /.col -->
      </div>
      <!-- /.row -->

      <!-- this row will not appear when printing -->
      <div class="row no-print">
        <div class="col-xs-12">
            <asp:button runat="server" OnClick="btn_addImport_Click" ID="btn_addImport" Text="حفظ"  cssclass="btn btn-success pull-right"/> 
          
         <%-- <button type="button" class="btn btn-primary pull-right" style="margin-right: 5px;">
            <i class="fa fa-download"></i> Generate PDF
          </button>--%>
        </div>
      </div>
    </section>
    <!-- /.content -->
    <div class="clearfix"></div>
   <script type="text/javascript">
       
       $('#birthday').maskInput(["MM: ", /[01]/, /\d/, " DD: ", /[0-3]/, /\d/, " YYYY: ", /[12]/, /[90]/, /\d/, /\d/]);
</script>
    <script>
      
           $('#ex_date,#Text1').daterangepicker({
               "singleDatePicker": true,
               "showDropdowns": true,
               "timePicker": true,
               "timePickerIncrement": 5,
               "autoApply": true,

               "locale": {
                   "format": "DD/MM/YYYY hh:mm A"

               }
           });
      
</script> 
</asp:Content>
