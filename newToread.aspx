<%@ Page Title="" Language="C#"  AutoEventWireup="true" CodeFile="newToread.aspx.cs" Inherits="newToread" %>

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
<%if (Session["role"] != null)
        {
           %>
    <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>


     <asp:Label Visible="false" ID="impid" runat="server" Text=""></asp:Label>
    <div class="row center-block  box box-warning bg-gray">

        <asp:UpdatePanel runat="server" id="UpdatePanel" updatemode="Conditional">
          <ContentTemplate>
            <script>
            Sys.Application.add_load(initdropdown);
            </script>
    
    
    <div class="col-md-3" >
     
       الكود :
            <asp:TextBox ClientIDMode="Static"  AutoPostBack="true" OnTextChanged="code_TextChanged1" class="form-control" ID="code" runat="server"></asp:TextBox>
       
        </div>
    <div class="col-md-3" >
      الاسم:
            <asp:DropDownList AutoPostBack="true" OnSelectedIndexChanged="name_SelectedIndexChanged1" CssClass="form-control js-example-placeholder-single"  class="form-control" ID="name" runat="server">
            </asp:DropDownList>
       
        </div>
    <div class="col-md-2">
       سعر الوحده:
            <asp:TextBox class="form-control" ID="price" runat="server"></asp:TextBox>
       
        </div>
    <div class="col-md-2">
        الكميه:
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
       <asp:Button id="addbtn" OnClick="addbtn_Click" cssClass="center-block btn btn-primary"  runat="server"  Text="اضافه"></asp:Button><br />
     
     </div>
    <asp:Panel id="editss" visible="false" runat="server">
        
        <div class="col-md-2">
            <br />
       <asp:Button onClick="btnEdit" cssClass="btn btn-flat bg-info"  runat="server"  Text="تعديل"></asp:Button>
       
        </div>
        <div class="col-md-2">
            <br />

       <asp:Button onClick="btnCancel"  cssClass="btn btn-flat bg-warning"  runat="server"  Text="الغاء"></asp:Button>
            <br />
            <br />
        
        </div>
        </asp:Panel>
      </ContentTemplate>
   </asp:UpdatePanel>
       
  </div>
                   
    
    <section class="invoice">
      <!-- title row -->
      <div class="row">
        <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره توريد:#<%=impid.Text %>
                
            <small class="pull-left">بتاريخ: <%=DateTime.Now.ToShortDateString() %></small>
          </h2>
        </div>
        <!-- /.col -->
      </div>
      
      <!-- Table row -->
      <div class="row">
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% 
FactoryDBEntities db = new FactoryDBEntities();
    int imp_id = int.Parse(impid.Text);
    var x = (from s in db.import_items where s.imp_id == imp_id select s).OrderBy(a=>a.prod_name).ToList();


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
                         int i = 1;
                         foreach (var item in x) { %>
            <tr>
              <td><%=i %></td>
              <td><%=item.prod_name %></td>
              <td><%=item.prod_code %></td>
              <td><%=item.quantity %></td>
              <td><%=item.price %></td>
              <td><%=item.total %></td>
              <td><a  href="newToread.aspx?edititem=<%=item.id %>">  <i class="fa fa-edit "></i></a></td>
              <td><a href="newToread.aspx?delitem=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>
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
              <% var sum = (from s in db.import_items where s.status == 0 && s.imp_id == imp_id select s.total).Sum(); %>
        <div class="table-responsive">
            <table class="table">
              <tr>
                <th style="width:50%">المبلغ:</th>
                <td>$<%=sum %></td>

               
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
          <div class="col-md-6"> 
  <div class="col-md-12"><br /><asp:FileUpload AllowMultiple="true" ID="FileUpload1" runat="server" /></div>
               <div class="col-md-12">   
                  <div class="col-md-6" >
                            <asp:RadioButtonList ID="RadioButtonList2" AutoPostBack="true" OnSelectedIndexChanged="RadioButtonList2_SelectedIndexChanged" runat="server" RepeatDirection="Horizontal">
                                <asp:ListItem Selected="True" Value="1">خزينه</asp:ListItem>
                                <asp:ListItem Value="2">بنك</asp:ListItem>
                            </asp:RadioButtonList>
                        </div>
                        <div class="=col-md-6">
                            <asp:DropDownList ID="DropDownList2" ToolTip="select"   Visible="false" CssClass="d form-control js-example-placeholder-single select2" runat="server" AppendDataBoundItems="True">
                           </asp:DropDownList>
                        </div>
                      </div> 
        <!-- /.col -->
           <div class="col-md-4">
           المورد:
            <asp:DropDownList  ID="DropDownList1"  ToolTip="select" CssClass="form-control js-example-placeholder-single select2" runat="server" >
            </asp:DropDownList>
                <asp:RequiredFieldValidator  ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="DropDownList1" ID="RequiredFieldValidator2" runat="server" ErrorMessage="اختار المورد"></asp:RequiredFieldValidator>
   
    </div>
       
                 <div class="col-md-3">
        تاريخ الفاتوره:
           <%-- <asp:TextBox TextMode="Date"  class="form-control" ID="ex_date" runat="server"></asp:TextBox>--%>
            <div class="input-group">
                      <div class="input-group-addon">
                        <i class="fa fa-clock-o"></i>
                      </div>
                <asp:TextBox TextMode="Date"  ID="Text1"  cssclass="form-control pull-right" runat="server"></asp:TextBox>
                      
                    </div>
                     <asp:RequiredFieldValidator  ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="Text1" ID="RequiredFieldValidator1" runat="server" ErrorMessage="ادخل التاريخ"></asp:RequiredFieldValidator>
      <!-- /.row -->
      </div>
               <div class="row no-print">
        <div class="col-xs-12">
            <asp:button runat="server" ValidationGroup="a" ID="btn_addImport" Text="حفظ" OnClick="btn_addImport_Click" cssclass="center-block btn btn-primary pull-right" onclientClick="target='_blank'"/> 
          
        
        </div>
      </div>
              </div>
        </div>

      <!-- this row will not appear when printing -->
     
    </section>
    <!-- /.content -->
    <div class="clearfix"></div>
   <script type="text/javascript">
       
       $('#birthday').maskInput(["MM: ", /[01]/, /\d/, " DD: ", /[0-3]/, /\d/, " YYYY: ", /[12]/, /[90]/, /\d/, /\d/]);
</script>
    <script>
        document.getElementById("code").focus();
        
      function SetCursorToTextEnd(textControlID) {
          var text = document.getElementById(textControlID);
          if (text != null && text.value.length > 0) {
              if (text.createTextRange) {
                  var range
  = text.createTextRange(); range.moveStart('character', text.value.length); range.collapse();
                  range.select();
              } else if (text.setSelectionRange) {
                  var textLength = text.value.length;
                  text.setSelectionRange(textLength, textLength);
              }
          }
      }
  
    </script>
    <% }%>
         <script>
     var time = new Date().getTime();
     //$(document.body).bind("mousemove keypress", function(e) {
     //    time = new Date().getTime();
     //});

     function refresh() {
         if(new Date().getTime() - time >= 600) 
         {  window.location.reload(true);}
         else 
             setTimeout(refresh, 100);
     }

</script>
    

</asp:Content>

    