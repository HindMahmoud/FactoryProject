<%@ Page Language="C#" AutoEventWireup="true"  MasterPageFile="~/Home.master" CodeFile="exchange.aspx.cs" Inherits="exchange" %>
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

    <div class="row" style="background-color:white">
        <div class="col-md-6" style="padding-right:6px">
     <asp:Label Visible="false" ID="impid" runat="server" Text=""></asp:Label>
    
    <div class="row box box-warning">
      <div class="col-md-6">
         رقم الفاتوره:
         <asp:TextBox OnTextChanged="inv_id_TextChanged" CssClass="form-control" AutoPostBack="true"  ID="inv_id" runat="server"></asp:TextBox>

     </div>
    <div class="col-md-6">
        الاصناف: 
   <asp:DropDownList ID="items" ToolTip="select" AutoPostBack="true" OnSelectedIndexChanged="items_SelectedIndexChanged" CssClass="form-control js-example-placeholder-single select2" runat="server">
       <asp:ListItem></asp:ListItem>
   </asp:DropDownList>

          </div>
    
  <div class="col-md-12"></div>
    

      <div class="col-md-6">
         الكميه :
         <asp:TextBox CssClass="form-control"   ID="qty" runat="server"></asp:TextBox>

     </div>

      <div class="col-md-6">
         سعر الوحده:
         <asp:TextBox CssClass="form-control"   ID="price" runat="server"></asp:TextBox>

     </div>
    
     
         <div class="col-md-12 text-center">
            <br />
            <asp:Button OnClick="Button1_Click"  CssClass="btn btn-primary" ID="Button1" runat="server" Text="اضافه" Style="margin-right:5px" />
             <br />
             <br />
        </div>

    <div class="clearfix"></div>


    <section class="invoice">
      <!-- title row -->
      <div class="row">
        <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره مرتجع:#<%=impid.Text %>
              </h2>
        </div>
        <!-- /.col -->
      </div>
    
      <div class="row">
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% 
    FactoryDBEntities db = new  FactoryDBEntities();
    int imp_id = int.Parse(impid.Text);
    var x = (from s in db.return_items where s.return_id == imp_id&&s.status==0 select s).ToList();


                   %>
            <thead>
               
            <tr>
              <th>#</th>
              <th>الصنف</th>
              <th>الكود #</th>
              <th>الكميه</th>
              <th>اجمالي السعر</th>
             <%-- <th>تاريخ الصلاحيه</th>--%>
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

            
         <td><a href="exchange.aspx?delitem=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>

                
    


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
                 
               
              </tr>
             
            </table>
          </div>
        </div>

        <!-- /.col -->
      </div>
      <!-- /.row -->

      <!-- this row will not appear when printing -->
     <%-- <div class="row no-print">
        <%--<div class="col-xs-12">
            <asp:button runat="server" OnClick="btn_addImport_Click" ID="btn_addImport" Text="حفظ"  cssclass="btn btn-success pull-right"/> 
          
        </div>
      </div>--%>
    </section>
            </div>
    </div>
        
        <div class="col-md-6" style="border-left:1px solid orange;"  >
    
    <asp:ScriptManager ID="ScriptManager1" runat="server"> </asp:ScriptManager>


     <asp:Label Visible="false" ID="invid" runat="server" Text=""></asp:Label>
    <div class="row box box-warning"  >
         <asp:UpdatePanel runat="server" id="UpdatePanel1" updatemode="Conditional">
<ContentTemplate>
   
   
    <div class="col-md-10">
       الكود :
            <asp:TextBox ClientIDMode="Static" TabIndex="1"  AutoPostBack="true" OnTextChanged="code_TextChanged" class="form-control" ID="code" runat="server"></asp:TextBox>
        <br />
       
        </div>
    
    <asp:Panel id="editss" visible="false" runat="server">
        <div class="col-md-3">
       سعر الوحده:
            <asp:TextBox class="form-control" ID="salesprice" runat="server"></asp:TextBox>
       
        </div>
        
    
     <div class="col-md-3">
        الكميه:
            <asp:TextBox class="form-control " ID="salesqty" runat="server"></asp:TextBox>
   
        </div>
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
       
        <div class="col-md-1" hidden>
       <%-- المتاح بالمخزن:--%>
            <asp:TextBox ReadOnly="true" class="form-control  bg-aqua" ID="TextBox3" runat="server"></asp:TextBox>
       
        </div>
    
 
    
    
     </ContentTemplate>
   </asp:UpdatePanel>
       
    </div>

  
    <!-- /.content -->


  
          <section class="invoice">
      <!-- title row -->
      <div class="row">
        <div class="col-xs-12">
          <h2 class="page-header">
            <i class="fa fa-newspaper-o"></i> فاتوره بيع:#<%=invid.Text %>
            <small class="pull-left">بتاريخ: <%=DateTime.Now.ToShortDateString() %></small>
          </h2>
        </div>
          
        <!-- /.col -->
      </div>
      
      <div class="row">
        <div class="col-xs-12 table-responsive">
          <table class="table table-striped">
              <% 
  
    int imp_idd = int.Parse(invid.Text);
    var xx = (from s in db.invoice_items where s.inv_id == imp_idd select s).OrderBy(a=>a.prod_name).ToList();


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
                 <%if (xx != null)
                     {
                         int i = 1; foreach (var item in xx) { %>
            <tr>
              <td><%=i %></td>
              <td><%=item.prod_name %></td>
              <td><%=item.prod_code %></td>
              

              <td><%=item.quantity %></td>
              <td><%=item.price %></td>
              
              <td><%=item.NetTotal %></td>
 <%if (Session["role"].ToString() != "Specific permission")
                    { %>
                  <td><a  href="exchange.aspx?edititem=<%=item.id %>">  <i class="fa fa-edit "></i></a></td>
         <%} %>
                <td><a href="exchange.aspx?delitem=<%=item.id %>"><i class="fa fa-trash-o text-red"></i></a></td>

                
    


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
                   <% var summ = (from s in db.invoice_items where s.status == 0 && s.inv_id == imp_idd select s.NetTotal).Sum();
                  
                   %>
                <th style="width:50%">المبلغ:</th>
                <td> $<%=summ %></td>

               
              </tr>
 
             <tr>
               <th style="width:50%">الخصم:</th>
                 
                <td>
                    <asp:TextBox  OnTextChanged="TextBox5_TextChanged" AutoPostBack="true"  CssClass="form-control" ID="TextBox5" runat="server"></asp:TextBox></td>
              </tr>
                
              <tr>
                <th>الصافي:</th>
                <td>$<asp:Label ID="total2"  runat="server"></asp:Label></td>
              </tr>
                 
              <tr>
                <th>السداد:</th>
                <td><asp:TextBox   CssClass="form-control" ID="pay" runat="server"></asp:TextBox></td>
                <td></td>
              </tr>
            </table>
          </div>
        </div>
   
              
        <!-- /.col -->
      </div>
      <!-- /.row -->

     
     <%-- <div class="row no-print">
         
        <div class="col-xs-9">
            <br />
           
        
        </div>
      </div>--%>
    </section>
      </div>
        
        </div>
    <div class="row">
        <hr style="height:2px;color:darkgray; width:100%"/>
        <div class="col-md-12" style="width:50%;margin-right:25%;border:1px solid darkgray;border-radius:5px;margin-top:2px;background:white; padding-bottom:5px">
        <table class="table no-border" >
              
              <tr>
                  
                <th style="width:50%">المبلغ:</th>
                <td style="font-size:16px;font:bold;color:green"> $<asp:Label ID="totalval"  runat="server"></asp:Label></td>

              </tr>
 <tr>
     <td colspan="2"> <asp:button runat="server" style="width:20%;"  ValidationGroup="b" ID="Button2" Text="حفظ" OnClientClick="target='_blank'"  OnClick="button2_Click" cssclass="btn btn-success pull-right"/> 
    </td>
 </tr>
            </table>
     </div>   
    </div>
      
</asp:Content>

