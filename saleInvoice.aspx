<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="saleInvoice.aspx.cs" Inherits="saleInvoice" %>


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
  <style>
      .d {padding:0px;
      width:136px}
  </style>
    
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">

    <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>


     <asp:Label Visible="false" ID="invid" runat="server" Text=""></asp:Label>
   <asp:Panel runat="server" Id="panel1">
     <div class="row box box-warning">
        <asp:UpdatePanel runat="server" id="UpdatePanel" updatemode="Conditional">
          <ContentTemplate>
            <script>
            Sys.Application.add_load(initdropdown);
            </script>
    
    
    <div class="col-md-3" >
       الكود :<span class="star-validation">*</span>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator4" runat="server" ValidationGroup="er" ErrorMessage="ادخل الكود" ControlToValidate="code"  ForeColor="red"></asp:RequiredFieldValidator>
        <asp:TextBox ClientIDMode="Static"  AutoPostBack="true" OnTextChanged="code_TextChanged" class="form-control" ID="code" runat="server"></asp:TextBox>
       
        </div>
    <div class="col-md-3" >
      الاسم:<span class="star-validation">*</span>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator5" runat="server" ValidationGroup="er" ErrorMessage="ادخل الاسم" ControlToValidate="name"  ForeColor="red"></asp:RequiredFieldValidator>
         <asp:DropDownList AutoPostBack="true"   OnSelectedIndexChanged="name_SelectedIndexChanged1" cssClass="form-control js-example-placeholder-single"   ID="name" runat="server">
            </asp:DropDownList>
        </div>
    <div class="col-md-2">
       سعر الوحده:<span class="star-validation">*</span>
         <asp:TextBox class="form-control" ID="price" runat="server"></asp:TextBox>
       </div>
    <div class="col-md-2">
        الكميه: <span class="star-validation">*</span>
        <asp:RequiredFieldValidator ID="RequiredFieldValidator7" runat="server" ValidationGroup="er" ErrorMessage="ادخل الكمية" ControlToValidate="qty"  ForeColor="red"></asp:RequiredFieldValidator>
        <asp:TextBox class="form-control " Text="1" ID="qty" runat="server"></asp:TextBox>
   
        </div>
    <div class="col-md-2" >
        المتاح بالمخزن:
            <asp:TextBox ReadOnly="true" class="form-control  bg-aqua" ID="TextBox2" runat="server"></asp:TextBox>
        </div>
    <br />
    <br />
    <br />
    <br />
    <div class="col-md-12">
       <asp:Button id="addbtn" OnClick="addbtn_Click" cssClass="center-block btn btn-primary" ValidationGroup="er"  runat="server"  Text="اضافه"></asp:Button><br />
     
     </div>
  <asp:Panel id="editss" visible="false" runat="server">
        
        <div class="col-md-2">
            <br />
       <asp:Button onClick="btnEdit_Click" ID="btnEdit" cssClass="btn btn-flat bg-info"  runat="server"  Text="تعديل"></asp:Button>
       </div>
        <div class="col-md-2">
            <br />

       <asp:Button onClick="btnCancel_Click" ID="btnCalcel"  cssClass="btn btn-flat bg-warning"  runat="server"  Text="الغاء"></asp:Button>
            <br />
            <br />
        
        </div>
        </asp:Panel>
      </ContentTemplate>
   </asp:UpdatePanel>
       
  </div>
     
       </asp:Panel>

    <section class="invoice">
      <!-- title row -->
      <div class="row">
        <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره بيع:#<%=invid.Text %>
            <small class="pull-left">بتاريخ: <%=DateTime.Now %></small>
          </h2>
        </div>
          
        <!-- /.col -->
      </div>
      
      <div class="row">
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% 
    FactoryDBEntities db = new  FactoryDBEntities();
    int imp_id = int.Parse(invid.Text);
    var x = (from s in db.invoice_items where s.inv_id == imp_id select s).OrderBy(a=>a.prod_name).ToList();


                   %>
            <thead>
               
            <tr>
              <th>#</th>
              <th>الصنف</th>
              <th>الكود #</th>
              <th>الكميه</th>
              <th> السعر</th>
              <th> الاجمالي</th>
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
              <td><%=item.price %></td>
              
              <td><%=item.NetTotal %></td>
              <td><a  href="saleInvoice.aspx?edititem=<%=item.id %>">  <i class="fa fa-edit "></i></a></td>
              <td><a href="saleInvoice.aspx?delitem=<%=item.id %>"><i class="fa fa-trash-o text-red"></i></a></td>
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
             
              
        <div class="table-responsive">

            <table class="table">
              <tr>
                   <% var sum = (from s in db.invoice_items where s.status == 0 && s.inv_id == imp_id select s.NetTotal).Sum();
                  
                   %>
                <th style="width:50%">المبلغ:</th>
                <td> $<%=sum %></td>

               
              </tr>
  <asp:UpdatePanel runat="server" id="UpdatePanel3" updatemode="Conditional">
<ContentTemplate>
             <tr>
               <th style="width:50%">الخصم:%</th>
                 
                <td>
                    <asp:TextBox Width="50%"  OnTextChanged="TextBox1_TextChanged" AutoPostBack="true"  CssClass="form-control" ID="TextBox1" runat="server"></asp:TextBox>
                   
                </td>
             
                </tr>
                
              <tr>
                <th>الصافي:</th>
                <td>$<asp:Label ID="total2"  runat="server"></asp:Label></td>
              </tr>
                 </ContentTemplate>
       </asp:UpdatePanel>
               <tr>
                <th>السداد:</th>
                <td><asp:TextBox Width="50%"   CssClass="form-control" ID="pay" runat="server"></asp:TextBox></td>
                <td></td>
              </tr>
            </table>
          </div>
        </div>
         
          <asp:UpdatePanel runat="server" id="UpdatePanel4" updatemode="Conditional">
<ContentTemplate>
           <div class="col-xs-6">
               <br />
               
                 <div class="col-md-12"><asp:FileUpload AllowMultiple="true" ID="FileUpload1" runat="server" /><br />   </div>
                  <div class="col-md-12">   
                  <div class="col-md-6" >
                            <asp:RadioButtonList ID="RadioButtonList2" AutoPostBack="true" OnSelectedIndexChanged="RadioButtonList2_SelectedIndexChanged" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">خزينه</asp:ListItem>
                                <asp:ListItem Value="2">بنك</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="=col-md-6">
                            <asp:DropDownList ID="DropDownList1" ToolTip="select"   Visible="false" CssClass="d form-control js-example-placeholder-single select2" runat="server" AppendDataBoundItems="True">
                           </asp:DropDownList>
                        </div>
                      </div> 
                <div class="col-md-5">
                العملاء: 
                    <asp:DropDownList ID="ddlclient"  ToolTip="select" style="padding:0"  CssClass="form-control js-example-placeholder-single select2" runat="server" AppendDataBoundItems="True" >
                    </asp:DropDownList>
              </div>
        <div class="col-md-5">
         الكاشير: 
   <asp:DropDownList ID="casherddl" ToolTip="select"  CssClass="form-control js-example-placeholder-single select2" runat="server" AppendDataBoundItems="True" DataSourceID="SqlDataSource1" DataTextField="name" DataValueField="id">
    </asp:DropDownList>
      <asp:SqlDataSource runat="server" ID="SqlDataSource1" ConnectionString='<%$ ConnectionStrings:FactoryDBConnectionString %>' SelectCommand="SELECT [id], [name] FROM [salesMen]"></asp:SqlDataSource>
    </div>
            <div class="col-md-1"><br /><button type="button" class="btn btn-info " data-toggle="modal" data-target="#myModal">اضافه عميل</button></div>
       
        </div>
    
   
  
      </ContentTemplate>
       </asp:UpdatePanel>
              
        <!-- /.col -->
      </div>
      <!-- /.row -->

     
      <div class="row no-print">
         
        <div class="col-xs-9">
            <br />
            <asp:button runat="server" ValidationGroup="b" ID="btn_addImport" OnClientClick="target='_blank'"  Text="حفظ" OnClick="btn_addImport_Click" cssclass="btn btn-success pull-right"/> 
          
        
        </div>
      </div>
    </section>
    <!-- /.content -->
    <div class="clearfix"></div>

    <div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog ">
      <div class="modal-content">
        <div class="modal-header">
          <button type="button" class="close" data-dismiss="modal">&times;</button>
          <h4 class="modal-title">اضافه عميل جديد</h4>
        </div>
        <div class="modal-body">
          
             <div class="col-md-12">
            اسم العميل:<span class="star-validation">*</span>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator3" runat="server" ErrorMessage="ادخل الاسم  " ControlToValidate="customere"  ValidationGroup="s" ForeColor="red"></asp:RequiredFieldValidator>
            <asp:TextBox CssClass="form-control" ID="customere" runat="server"></asp:TextBox>
        </div>
        
        <div class="col-md-12">
            رقم الهاتف<span class="star-validation">*</span>
             <asp:RequiredFieldValidator ID="RequiredFieldValidator1" runat="server" ErrorMessage="ادخل رقم الهاتف  " ControlToValidate="phone"  ValidationGroup="s" ForeColor="red"></asp:RequiredFieldValidator>
            
            <asp:TextBox CssClass="form-control" ID="phone" runat="server"></asp:TextBox>
        </div>
            <div class="col-md-12">
         العنوان
            <asp:TextBox CssClass="form-control" ID="address" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-12">
         القيمه
             <asp:RequiredFieldValidator ID="RequiredFieldValidator2" runat="server" ErrorMessage="ادخل القيمة  " ControlToValidate="initval"  ForeColor="red"></asp:RequiredFieldValidator>
             <asp:TextBox CssClass="form-control" ID="initval" Text="0" runat="server"></asp:TextBox>
        </div>
         <div class="col-md-12">
           تاريخ الميلاد
            <asp:TextBox  TextMode="Date" CssClass="form-control" ID="birthdate" runat="server"></asp:TextBox>
        </div>
        
           
       
        </div>
        <div class="modal-footer">
        <div class="col-md-12 pull-left">
           <br />
            <asp:Button CssClass="btn btn-primary"  ValidationGroup="s" OnClick="add_Click"  ID="add" Text="اضافه" runat="server"></asp:Button>
              <button type="button" class="btn btn-danger" data-dismiss="modal">اغلاق</button>
          </div>
        </div>
      </div>
    </div>
  </div>


 
</asp:Content>

