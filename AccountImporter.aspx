<%@ Page Title="" Language="C#" MasterPageFile="~/Home.master" AutoEventWireup="true" CodeFile="AccountImporter.aspx.cs" Inherits="AccountImporter" %>

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
    <style>        .d {
   padding:0px     }
    </style>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" Runat="Server">
    <%if (Session["role"] != null)
        {
            if (Session["role"].ToString() == "All permission")
            {


             %>
    <div class="row">
         <%  FactoryDBEntities db = new FactoryDBEntities();
             int x=0;
             if (!String.IsNullOrEmpty(Convert.ToString(Request.QueryString["id"])))
             {
                  x = int.Parse(Request.QueryString["id"].ToString());
             }
              importer it = db.importer.FirstOrDefault(a => a.id == x);
              %>
        <div class="col-md-4">
            <div class="row">
                <div class="col-md-12">
            <div class="box box-primary">
            <div class="box-body box-profile">
             <h3 class="profile-username text-center"><%=it.name.ToString()%></h3>
             <ul class="list-group list-group-unbordered">
                <li class="list-group-item">
                  <b>الهاتف: </b><span class="text-blue"><%=it.phone.ToString() %></span>
                </li>
                  <li class="list-group-item">
                 <b>العنوان: </b><span class="text-blue"><%=it.address.ToString() %></span>
                </li>
                  <li class="list-group-item bg-blue-gradient">
                      <%  var daansumation = (from ff in db.importer_account where ff.importer_id == x select ff.daan).Sum();
                          var mdeensumation = (from ff in db.importer_account where ff.importer_id == x select ff.mdeen).Sum();
                          

                          double ?acc =  mdeensumation-daansumation; %>
                      <b>حساب المورد $$ </b><span class="bg-red-gradient "><%=acc.ToString() %></span>
                  </li>

                  </ul>
                </div>
                </div>
                </div>
                
                <div class="col-md-12 box box-primary">
                    <div class="row">
                        <br />
                        <div class="col-md-12">
                            البيان: <asp:RequiredFieldValidator  ForeColor="Red" ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="title" ID="RequiredFieldValidator1" runat="server" ErrorMessage=" اختار البيان"></asp:RequiredFieldValidator>
        
                            <asp:DropDownList  ToolTip="select" CssClass="form-control js-example-placeholder-single select2" ID="title" runat="server">
                                <asp:ListItem>فاتوره</asp:ListItem>
                                <asp:ListItem>سداد</asp:ListItem>
                                <asp:ListItem>مرتجع</asp:ListItem>
                            </asp:DropDownList>
                        </div>
                        <div class="col-md-12">
                            القيمه: <asp:RequiredFieldValidator  ForeColor="Red" ValidationGroup="a" CssClass="text-red text-bold list-group-item-text" ControlToValidate="value" ID="RequiredFieldValidator2" runat="server" ErrorMessage="ادخل القيمه"></asp:RequiredFieldValidator>
        
                            <asp:TextBox CssClass="form-control" ID="value" runat="server"></asp:TextBox>
                        </div>
                       
                         <div class="col-md-12">
                            
                            <asp:RadioButtonList ID="RadioButtonList1" runat="server" RepeatDirection="Horizontal" AutoPostBack="true" OnSelectedIndexChanged="RadioButtonList1_SelectedIndexChanged">
                                <asp:ListItem Selected="True" Value="1">خزينه</asp:ListItem>
                                <asp:ListItem Value="2">بنك</asp:ListItem>
                            </asp:RadioButtonList>
                              <asp:DropDownList  CssClass="form-control d" ID="bankddl" Visible="false"   runat="server">
                               </asp:DropDownList>
                        </div>
                       
                        <div class="col-md-12 ">
                            <br/>
                            <asp:Button Text="اضافه"  CausesValidation="true" ValidationGroup="a" OnClick="btnadd_Click" CssClass="btn btn-primary" ID="btnadd" runat="server"></asp:Button>
                        <br />
                        </div>

                    </div>
                        
                 <br />                    
                 </div>
                </div>
            
        </div>
        <div class="col-md-8" style="overflow-y:auto;height:500px">

             <div class="box box-primary">
            <div class="box-header">
              <h3 class="box-title">كشف حساب</h3>

              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search" class="form-control pull-right" onkeyup="myFunction1()" placeholder="Search">

                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable">
                  <% 

                      var lab = (from ss in db.importer_account where ss.importer_id == x select ss).ToList();
                      if (lab != null)
                      {
                       %>
                <tr>
                  <th>#</th>
                  <th>التاريخ</th>
                  <th>البيان</th>
                  <th>دائن </th>
                  <th>مدين</th>
                 
                  <th></th>
                  <th></th>
                </tr>
                  <% int i = 1; foreach (var item in lab)
                      {
                           %> 
                      
                <tr>
                 <td> <% Response.Write(i); %></td>
                 <td><% Response.Write(Convert.ToDateTime(item.date.ToString())); %></td>
                 <td><% Response.Write(item.title); %></td>

                 <td><% Response.Write(item.daan); %></td>
                 <td><% Response.Write(item.mdeen); %></td>
               
                 <td><a href="AccountImporter.aspx?id=<%=item.importer_id %>&&delinv=<%=item.id %>">  <i class="fa fa-trash-o text-red"></i></a></td>
                 <td><a href="AccountImporter.aspx?id=<%=item.importer_id %>&&print=<%=item.id %>">  <i class="fa fa-print text-blue"></i></a></td>


                

                </tr>
                    <%  i++;
                            }
                        }
                       %>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
         
        
        <div  style="overflow-y:auto;height:500px">
  <div class="box">
            <div class="box-header">
              <h3 class="box-title">فواتير </h3>
                
              <div class="box-tools">
                <div class="input-group input-group-sm" style="width: 150px;">
                  <input type="text" name="table_search" id="search2" class="form-control pull-right" onkeyup="myFunction2()" placeholder="search..">

                  <%--<div class="input-group-btn">
                    <button type="submit" class="btn btn-default"><i class="fa fa-search"></i></button>
                  </div>--%>
                </div>
              </div>
            </div>
            <!-- /.box-header -->
            <div class="box-body table-responsive no-padding">
              <table class="table table-hover" id="mytable2">
                  <% 
                      
                      var xx = (from ss in db.import where ss.importer_id==x where ss.id !=0&&ss.roleType==roleType select ss).ToList();
                      if (xx != null)
                      {
                       %>
                <tr>
                  
                    <th>الفاتوره#</th>
                    <th>التاريخ#</th>
                    <th>المورد</th>
                    <th>الاجمالي</th>
                   <th>نسبه الخصم %</th>
                    <th>الاجمالي بعد الخصم</th>
                    <th></th>
                </tr>
                  <% foreach (var item in xx)
    {
                           DateTime dd = Convert.ToDateTime(item.date);
                          string ddd = dd.ToString("yyyy/MM/dd");
                           %> 
                      
                <tr>
                   <td class="text-bold  fa fa-share" style="font-size:large"> <a href="editImport.aspx?id=<%=item.id %>"><% Response.Write(item.id); %></a></td>
                 <td><% Response.Write(ddd); %></td>
                 <td><% Response.Write(item.importer_name); %></td>
                 <td><% Response.Write(item.total); %></td>
                <td><% Response.Write(item.discount); %></td>
                 <td><% Response.Write(item.Net_total); %></td>
                 <td><a  href='AccountImporter.aspx?id=<%=x %>&&impprint=<%=item.id %>'>  <i class="fa fa-print text-blue"></i></a></td>
                 <td><a  href='AccountImporter.aspx?id=<%=x %>&&impdelete=<%=item.id %>'>  <i class="fa fa-trash-o text-red"></i></a></td>
                </tr>
                    <%  }
    }%>
               
              </table>
            </div>
            <!-- /.box-body -->
          </div>
    </div>
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

