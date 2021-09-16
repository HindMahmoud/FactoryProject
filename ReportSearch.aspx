<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="ReportSearch.aspx.cs" Inherits="ReportSearch" %>

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

         <div class="col-md-12">
             
              <ul class="timeline">
                 <li>
                  
                  <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-file-code-o text-green"></i>ايرادات:</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="from1" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="to1" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 
                                <%-- <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button3_Click"  ID="Button3" runat="server" Text="عرض" />
                                     </div>--%>

                             </div>


                        </div>
                    
                  </div>

                      <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-file-pdf-o text-red"></i>مصروفات:</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="from2" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="to2" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 
                                 <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button1_Click"  ID="Button1" runat="server" Text="عرض" />
                                     </div>

                             </div>


                        </div>
                    
                  </div>


                      <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-newspaper-o text-blue"></i>فواتير توريد :</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="from3" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="to3" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 
                                 <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button2_Click"  ID="Button2" runat="server" Text="عرض" />
                                     </div>

                             </div>


                        </div>
                    
                  </div>
 
                       <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-newspaper-o text-orange"></i>فواتير مرتجع:</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="from5" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="to5" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 
                                 
                                 <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button5_Click"  ID="Button5" runat="server" Text="عرض" />
                                     </div>

                             </div>


                        </div>
                    
                  </div>
                     
                        <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-dollar text-green"></i>فواتير اعادة التصنيع:</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="TextBox1" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="TextBox2" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 
                                 <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button7_Click"  ID="Button7" runat="server" Text="عرض" />
                                     </div>

                             </div>


                        </div>
                    
                  </div>
                     
                       <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-newspaper-o text-aqua"></i>الاصناف :</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="from6" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="to6" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                   <div class="col-md-3">
        الصنف: 
   <asp:DropDownList ID="name" ToolTip="select" CssClass="form-control js-example-placeholder-single select2" runat="server" AppendDataBoundItems="True" DataSourceID="aa" DataTextField="name" DataValueField="code">
       <asp:ListItem></asp:ListItem>
   </asp:DropDownList>

         <asp:SqlDataSource runat="server" ID="aa" ConnectionString='<%$ ConnectionStrings:FactoryDBConnectionString %>' SelectCommand="SELECT [code], [name] FROM [stock] WHERE ([roleType] =@roletype)">
             <SelectParameters>
                 <asp:Parameter DefaultValue="factory" Name="roletype" Type="String"></asp:Parameter>
             </SelectParameters>
         </asp:SqlDataSource>
     </div>

                                 
                                 
                                 <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button6_Click"  ID="Button6" runat="server" Text="عرض" />
                                     </div>

                             </div>


                        </div>
                    
                  </div>
 
                       <div class="timeline-item">
                  
                    <h3 class="timeline-header"> <i class="fa fa-x fa-dollar text-green"></i>الربح:</h3>
                       
                        <div class="timeline-body">
                             <div class="row">
                                
                                  <div class="col-md-3">
                                    من:<asp:TextBox ID="from4" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 <div class="col-md-3">
                                    الي:<asp:TextBox ID="to4" TextMode="Date" CssClass="form-control" runat="server"></asp:TextBox>
                                   </div>
                                 
                                 <div class="col-md-3">
                                     <br />
                                     <asp:Button  CssClass="btn btn-primary" OnClick="Button4_Click"  ID="Button4" runat="server" Text="عرض" />
                                     </div>

                             </div>


                        </div>
                    
                  </div>
 
 
                </li>
                  </ul>


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

