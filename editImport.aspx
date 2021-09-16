<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="editImport.aspx.cs" Inherits="editImport" %>

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

       
    <script>
        Sys.Application.add_load(initdropdown);
       

        </script>
    
     <div class="col-md-3">
        الصنف: <%--DataSourceID="prodd" DataTextField="name" DataValueField="code"--%>
         <asp:DropDownList  ID="name" ToolTip="select" CssClass="form-control js-example-placeholder-single select2" runat="server"   AppendDataBoundItems="True" OnSelectedIndexChanged="name_SelectedIndexChanged" AutoPostBack="True">
             <asp:ListItem></asp:ListItem>
         </asp:DropDownList>
  </div>
  
    
        <div class="col-md-2">
       سعر الوحده:
            <asp:TextBox class="form-control" ID="price" runat="server"></asp:TextBox>
       
        </div>
        
         <div class="col-md-2">
        الكميه:
            <asp:TextBox class="form-control bg-maroon-gradient" ID="qty" runat="server"></asp:TextBox>
       
        </div>
       
        <div class="col-md-2">
        المتاح بالمخزن:
            <asp:TextBox ReadOnly="true" class="form-control  bg-aqua" ID="TextBox2" runat="server"></asp:TextBox>
       
        </div>
        
       <div class="col-md-12 text-center">
            <br />
            <asp:Button  CssClass="btn btn-primary" OnClick="Button1_Click" ID="Button1" runat="server" Text="اضافه" />
        </div>

    </div>

      <div class="row">
     <asp:Panel ID="message" CssClass="col-md-6 " runat="server" Visible="false">
                    
     <div class="modal-content  ">
      <div class="modal-header bg-red ">
       
        <h4 class="modal-title ">تحذير</h4>
      </div>
      <div class="modal-body bg-red-gradient">
        <p>هل تريد الحذف</p><br />
          <div class="row">
          <div class="col-md-2"><asp:Button CssClass="bg-blue-gradient btn"  OnClick="yes_Click" ID="yes" runat="server" Text="نعم" /></div>
          <div class="col-md-2"> <asp:Button CssClass="bg-yellow-active btn"  OnClick="no_Click" ID="no" runat="server" Text="لا" /></div>
              </div>
         </div>
    </div>
                </asp:Panel>
        </div>
    <section class="invoice">
<% FactoryDBEntities db = new  FactoryDBEntities();
    int imppid = 0;
    if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
    {
        imppid = int.Parse(Request.QueryString["id"].ToString());
    }
    else Response.Redirect("newToread.aspx");
    import im = db.import.FirstOrDefault(a => a.id == imppid);
%>
      <!-- title row -->
      <div class="row">
        <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره توريد:#<%=impid.Text %>
                
            <small class="pull-left">بتاريخ: <%=im.date.ToString() %></small>
          </h2>
        </div>
        <!-- /.col -->
      </div>
      <!-- info row -->
    
      <!-- Table row -->
      <div class="row">
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% var x = (from s in db.import_items where s.imp_id == imppid select s).OrderBy(a=>a.prod_name).ToList();
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
                         int i = 1; foreach (var item in x) { %>
            <tr>
              <td><%=i %></td>
              <td><%=item.prod_name %></td>
              <td><%=item.prod_code %></td>
              <td><%=item.quantity %></td>
              <td><%=item.total %></td>

         <td><a href="editImport.aspx?id=<%=item.imp_id %>&&delitem=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>
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
       
          <div class="col-xs-6">
          <p class="lead">اجمالي الفاتوره:</p>
              <% var sum = (from s in db.import_items where s.status == 0 && s.imp_id == imppid select s.total).Sum(); %>
        <div class="table-responsive">
            <table class="table">
              <tr>
                <th style="width:50%">المبلغ:</th>
                <td>
                    <asp:Label ID="sum" runat="server" Text="0"></asp:Label></td>

               
              </tr>
      <asp:UpdatePanel runat="server" id="UpdatePanel3" updatemode="Conditional">
       <ContentTemplate>
             <tr>
               <th style="width:50%">الخصم:</th>
                <td><asp:TextBox Width="50%" Text="0" OnTextChanged="TextBox1_TextChanged" AutoPostBack="true"  CssClass="form-control" ID="TextBox1" runat="server"></asp:TextBox></td>
              </tr>
                
              <tr>
                <th>الصافي:</th>
                <td>$<asp:Label ID="total2" runat="server" Text="0"></asp:Label></td>
              </tr>
                 </ContentTemplate>
       </asp:UpdatePanel>
               
                 
              <tr>
                <th>السداد:</th>
                <td><asp:TextBox Width="50%" Text="0"  CssClass="form-control" ID="pay" runat="server"></asp:TextBox></td>
                <td></td>
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
            <asp:button runat="server" ID="btn_addImport" Text="حفظ" OnClick="btn_addImport_Click" cssclass="btn btn-success pull-right"/> 
          
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
                   "format": "YYYY/MM/DD"

               }
           });
      
</script> 
</asp:Content>

