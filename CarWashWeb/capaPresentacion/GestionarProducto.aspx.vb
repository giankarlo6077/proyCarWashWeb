Imports System.Data
Imports System.Web.UI
Imports System.Web.UI.WebControls

Partial Class capaPresentacion_GestionarProducto
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        CType(Master, Site_master).OpcionActiva = "gestionar"
        If Not IsPostBack Then
            listarcbo()
            listar("")
        End If
    End Sub

    Private Sub listar(ByVal dato As String)
        Try
            Dim obj As New capaNegocio.clsProducto()
            Dim dt As DataTable = obj.listarIdNombre(dato)
            Dim tabla As New DataTable()
            tabla.Columns.Add("Id")
            tabla.Columns.Add("Nombre")
            tabla.Columns.Add("stock")
            tabla.Columns.Add("vigencia")
            tabla.Columns.Add("Precio")
            tabla.Columns.Add("TipoProducto")
            tabla.Columns.Add("Marca")
            For Each fila As DataRow In dt.Rows
                tabla.Rows.Add(fila("idproducto"), fila("producto"), fila("stock"), fila("vigencia"),
                               fila("precioactual"), fila("tipoproducto"), fila("marcaproducto"))
            Next
            tblProducto.DataSource = tabla
            tblProducto.DataBind()
        Catch ex As Exception
            mostrar("Error al listar productos: " & ex.Message, False)
        End Try
    End Sub

    Public Sub listarcbo()
        Try
            Dim objMarca As New capaNegocio.clsMarca()
            Dim dtMarca As DataTable = objMarca.listarMarca()
            cboMarcaProducto.DataSource = dtMarca
            cboMarcaProducto.DataTextField = "marcaproducto"
            cboMarcaProducto.DataValueField = "idmarcaproducto"
            cboMarcaProducto.DataBind()
            cboMarcaProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))

            Dim objTipo As New capaNegocio.clsTipoProducto()
            Dim dtTipo As DataTable = objTipo.listarTipoProducto()
            cboTipoProducto.DataSource = dtTipo
            cboTipoProducto.DataTextField = "tipoproducto"
            cboTipoProducto.DataValueField = "idtipoproducto"
            cboTipoProducto.DataBind()
            cboTipoProducto.Items.Insert(0, New ListItem("-- Seleccione --", ""))
        Catch ex As Exception
            mostrar("Error al cargar combos: " & ex.Message, False)
        End Try
    End Sub

    Private Sub limpiar()
        cboMarcaProducto.SelectedIndex = 0
        cboTipoProducto.SelectedIndex = 0
        chkVigencia.Checked = True
        txtId.Text = ""
        spnStock.Text = "0"
        txtNombre.Text = ""
        txtPrecio.Text = ""
    End Sub

    Private Sub mostrar(ByVal texto As String, ByVal ok As Boolean)
        lblMsg.Text = texto
        lblMsg.CssClass = "msg show " & If(ok, "ok", "err")
    End Sub

    Protected Sub tblProducto_SelectedIndexChanged(sender As Object, e As EventArgs)
        Dim fila As GridViewRow = tblProducto.SelectedRow
        txtId.Text = fila.Cells(0).Text
        txtNombre.Text = Server.HtmlDecode(fila.Cells(1).Text)
        spnStock.Text = fila.Cells(2).Text
        chkVigencia.Checked = (fila.Cells(3).Text = "True" OrElse fila.Cells(3).Text = "1")
        txtPrecio.Text = fila.Cells(4).Text
        SeleccionarPorTexto(cboTipoProducto, Server.HtmlDecode(fila.Cells(5).Text))
        SeleccionarPorTexto(cboMarcaProducto, Server.HtmlDecode(fila.Cells(6).Text))
    End Sub

    Private Sub SeleccionarPorTexto(ByVal ddl As DropDownList, ByVal texto As String)
        Dim item As ListItem = ddl.Items.FindByText(texto)
        ddl.ClearSelection()
        If item IsNot Nothing Then item.Selected = True
    End Sub

    Protected Sub btnBuscar_Click(sender As Object, e As EventArgs) Handles btnBuscar.Click
        If String.IsNullOrWhiteSpace(txtId.Text) Then
            mostrar("Ingrese un ID para buscar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsProducto()
            Dim fila As DataRow = obj.buscarXid(Convert.ToInt32(txtId.Text))
            If fila IsNot Nothing Then
                txtNombre.Text = Convert.ToString(fila("producto"))
                spnStock.Text = Convert.ToString(fila("stock"))
                chkVigencia.Checked = Convert.ToBoolean(fila("vigencia"))
                txtPrecio.Text = Convert.ToString(fila("precioactual"))
                SeleccionarPorTexto(cboMarcaProducto, Convert.ToString(fila("marcaproducto")))
                SeleccionarPorTexto(cboTipoProducto, Convert.ToString(fila("tipoproducto")))
            Else
                mostrar("No se encontró el producto con ese ID", False)
            End If
        Catch ex As Exception
            mostrar("Error al buscar: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnNuevo_Click(sender As Object, e As EventArgs) Handles btnNuevo.Click
        If btnNuevo.Text = "Nuevo" Then
            btnNuevo.Text = "Guardar"
            limpiar()
            Try
                Dim obj As New capaNegocio.clsProducto()
                txtId.Text = obj.generarCodigoProducto().ToString()
            Catch ex As Exception
                mostrar("Error al generar el código del producto: " & ex.Message, False)
            End Try
        Else
            If String.IsNullOrWhiteSpace(txtNombre.Text) Then
                mostrar("Ingrese el nombre del producto", False)
                Return
            End If
            If cboTipoProducto.SelectedIndex <= 0 Then
                mostrar("Seleccione el tipo de producto", False)
                Return
            End If
            If cboMarcaProducto.SelectedIndex <= 0 Then
                mostrar("Seleccione la marca del producto", False)
                Return
            End If
            Dim precio As Decimal
            If Not Decimal.TryParse(txtPrecio.Text, precio) Then
                mostrar("Ingrese un precio válido", False)
                Return
            End If

            btnNuevo.Text = "Nuevo"
            Try
                Dim obj As New capaNegocio.clsProducto()
                Dim id As Integer = obj.generarCodigoProducto()
                Dim idMarca As Integer = Convert.ToInt32(cboMarcaProducto.SelectedValue)
                Dim idTipo As Integer = Convert.ToInt32(cboTipoProducto.SelectedValue)
                obj.registrarProducto(id, txtNombre.Text, Convert.ToInt32(spnStock.Text), chkVigencia.Checked, precio, idTipo, idMarca)
                mostrar("PRODUCTO REGISTRADO", True)
                limpiar()
            Catch ex As Exception
                mostrar("Error al registrar: " & ex.Message, False)
            End Try
            listar("")
        End If
    End Sub

    Protected Sub btnModificar_Click(sender As Object, e As EventArgs) Handles btnModificar.Click
        If String.IsNullOrWhiteSpace(txtId.Text) Then
            mostrar("Seleccione un producto para modificar", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsProducto()
            Dim idMarca As Integer = Convert.ToInt32(cboMarcaProducto.SelectedValue)
            Dim idTipo As Integer = Convert.ToInt32(cboTipoProducto.SelectedValue)
            obj.modificarProducto(Convert.ToInt32(txtId.Text), txtNombre.Text, Convert.ToInt32(spnStock.Text),
                                  chkVigencia.Checked, Convert.ToDecimal(txtPrecio.Text), idTipo, idMarca)
            mostrar("PRODUCTO MODIFICADO", True)
        Catch ex As Exception
            mostrar("Error al modificar: " & ex.Message, False)
        End Try
        listar("")
    End Sub

    Protected Sub btnLimpiar_Click(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        limpiar()
    End Sub

    Protected Sub btnDarsebaja_Click(sender As Object, e As EventArgs) Handles btnDarsebaja.Click
        If String.IsNullOrWhiteSpace(txtId.Text) Then
            mostrar("Escoja un ID para dar de baja", False)
            Return
        End If
        Try
            Dim obj As New capaNegocio.clsProducto()
            obj.darbajaProducto(Convert.ToInt32(txtId.Text))
            mostrar("PRODUCTO DADO DE BAJA", True)
        Catch ex As Exception
            mostrar("Error al dar de baja: " & ex.Message, False)
        End Try
        listar("")
    End Sub

End Class
