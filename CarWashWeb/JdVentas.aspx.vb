Imports System.Collections.Generic
Imports System.Data
Imports System.Data.SqlClient
Imports capaNegocio

Partial Class JdVentas
    Inherits System.Web.UI.Page

    Dim objVenta As New clsVenta()
    Dim objCliente As New clsCliente()
    Dim objComprobante As New clsComprobante()
    Dim objProducto As New clsProducto()

    ' Clave del carrito (detalle) en sesión
    Private Const KEY_DETALLE As String = "ventas_detalle"

    '================================================================
    ' CARGA DEL FORMULARIO
    '================================================================
    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        ' Búsqueda de cliente en vivo (filtrado del lado del cliente, sin postback)
        txtCliente.Attributes("onkeyup") = "filtrarTabla(this, '" & dgvCliente.ClientID & "');"

        If Not Page.IsPostBack Then
            Try
                InicializarDetalle()
                CargarClientes()
                AutocompletarCabecera()
                BindDetalle()
            Catch ex As Exception
                MostrarMensaje(lblMensaje, "Error al cargar la página: " & ex.Message, False)
            End Try
        End If

    End Sub

    '================================================================
    ' CARRITO EN SESIÓN  (reemplaza a la variable dtDetalle de escritorio)
    '================================================================
    Private Sub InicializarDetalle()
        Dim dt As New DataTable()
        dt.Columns.Add("producto", GetType(String))
        dt.Columns.Add("cantidad", GetType(Integer))
        dt.Columns.Add("precioVenta", GetType(Decimal))
        dt.Columns.Add("subtotal", GetType(Decimal))
        Session(KEY_DETALLE) = dt
    End Sub

    Private Function GetDetalle() As DataTable
        If Session(KEY_DETALLE) Is Nothing Then InicializarDetalle()
        Return CType(Session(KEY_DETALLE), DataTable)
    End Function

    Private Sub BindDetalle()
        Dim dt As DataTable = GetDetalle()
        dgvDetalle.DataSource = dt
        dgvDetalle.DataBind()
        ActualizarTotal()
    End Sub

    Private Sub ActualizarTotal()
        Dim total As Decimal = 0
        For Each fila As DataRow In GetDetalle().Rows
            total += Convert.ToDecimal(fila("subtotal"))
        Next
        txtTotal.Text = total.ToString("N2")
    End Sub

    '================================================================
    ' CABECERA: fecha, hora y número de comprobante
    '================================================================
    Private Sub AutocompletarCabecera()
        txtFecha.Text = Date.Now.ToString("yyyy-MM-dd")
        txtHora.Text = Date.Now.ToString("HH:mm:ss")
        ActualizarNumComprobante()
    End Sub

    Private Sub ActualizarNumComprobante()
        Dim tipo As String = cboTipoComprobante.SelectedValue
        Try
            Dim num As String = objComprobante.mostrarNuevoNumeroComprobante(tipo)
            If String.IsNullOrWhiteSpace(num) Then
                num = If(tipo = "Factura", "F001", "B001") & "-00000001"
            End If
            txtNumeroVenta.Text = num
        Catch
            txtNumeroVenta.Text = If(tipo = "Factura", "F001", "B001") & "-00000001"
        End Try
    End Sub

    Protected Sub cboTipoComprobante_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        ActualizarNumComprobante()
    End Sub

    ' VOLVER AL MENÚ PRINCIPAL
    Protected Sub btnVolver_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub

    '================================================================
    ' CLIENTES (grilla + búsqueda en tiempo real)
    '================================================================
    Private Sub CargarClientes(Optional ByVal filtro As String = "")
        Dim dt As DataTable = objCliente.listarClientesConTipo()
        If Not String.IsNullOrWhiteSpace(filtro) Then
            Dim dv As New DataView(dt)
            dv.RowFilter = "cliente LIKE '%" & filtro.Replace("'", "''") & "%'"
            dgvCliente.DataSource = dv
        Else
            dgvCliente.DataSource = dt
        End If
        dgvCliente.DataBind()
    End Sub

    Protected Sub dgvCliente_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName = "SelCliente" Then
            hdnClienteNombre.Value = e.CommandArgument.ToString()
            lblClienteSel.Text = "Cliente seleccionado: " & hdnClienteNombre.Value
        End If
    End Sub

    '================================================================
    ' ABRIR MODAL SELECCIONAR PRODUCTO
    '================================================================
    Protected Sub btnAgregar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Try
            CargarTiposProducto()
            CargarTodosLosProductos()
            lblMsgProducto.Visible = False
            pnlModalProducto.Visible = True
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error al abrir productos: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnCerrarProducto_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlModalProducto.Visible = False
    End Sub

    ' Combo de tipos de producto (igual que el escritorio: consulta directa a la BD)
    Private Sub CargarTiposProducto()
        Dim strSQL As String =
            "SELECT idtipoproducto, tipoproducto FROM tipo_producto ORDER BY tipoproducto ASC"

        Dim objC As New capaDatos.clsConectaBD()
        Try
            objC.conectar()
            Dim da As New SqlDataAdapter(strSQL, objC.miConexion)
            Dim dt As New DataTable()
            da.Fill(dt)

            Dim filaTodos As DataRow = dt.NewRow()
            filaTodos("idtipoproducto") = 0
            filaTodos("tipoproducto") = "-- Todos --"
            dt.Rows.InsertAt(filaTodos, 0)

            cboTipoProducto.DataSource = dt
            cboTipoProducto.DataTextField = "tipoproducto"
            cboTipoProducto.DataValueField = "idtipoproducto"
            cboTipoProducto.DataBind()
            cboTipoProducto.SelectedIndex = 0
        Finally
            objC.desconectar()
        End Try
    End Sub

    Private Sub CargarTodosLosProductos()
        dgvProductos.DataSource = objProducto.listarIdNombre("*")
        dgvProductos.DataBind()
    End Sub

    Protected Sub cboTipoProducto_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        Try
            Dim idTipo As Integer = Convert.ToInt32(cboTipoProducto.SelectedValue)
            If idTipo = 0 Then
                dgvProductos.DataSource = objProducto.listarIdNombre("*")
            Else
                dgvProductos.DataSource = objProducto.listarProductosPorTipoProducto(cboTipoProducto.SelectedItem.Text)
            End If
            dgvProductos.DataBind()
            pnlModalProducto.Visible = True
        Catch ex As Exception
            pnlModalProducto.Visible = True
            MostrarMensaje(lblMsgProducto, "Error al filtrar: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' AGREGAR PRODUCTO AL DETALLE (desde la grilla del modal)
    '================================================================
    Protected Sub dgvProductos_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "AgregarProd" Then Exit Sub

        pnlModalProducto.Visible = True

        Try
            Dim fila As GridViewRow = CType(CType(e.CommandSource, Control).NamingContainer, GridViewRow)
            Dim txtCantidad As TextBox = CType(fila.FindControl("txtCantidad"), TextBox)

            ' Leemos los valores desde los DataKeys (no del texto formateado de la celda)
            Dim claves As DataKey = dgvProductos.DataKeys(fila.RowIndex)
            Dim idProducto As Integer = Convert.ToInt32(claves("idproducto"))
            Dim nombre As String = claves("producto").ToString()
            Dim precio As Decimal = Convert.ToDecimal(claves("precioactual"))
            Dim stock As Integer = Convert.ToInt32(claves("stock"))

            Dim cantidad As Integer
            If Not Integer.TryParse(txtCantidad.Text.Trim(), cantidad) OrElse cantidad < 1 Then
                MostrarMensaje(lblMsgProducto, "Ingrese una cantidad válida (mínimo 1).", False)
                Exit Sub
            End If

            If stock = 0 Then
                MostrarMensaje(lblMsgProducto, "El producto seleccionado no tiene stock disponible.", False)
                Exit Sub
            End If

            If cantidad > stock Then
                MostrarMensaje(lblMsgProducto, "Stock insuficiente. Disponible: " & stock & " unidades.", False)
                Exit Sub
            End If

            ' Descontar stock en BD (igual que el escritorio)
            objProducto.Aumentar_DisminuirStock(cantidad, idProducto, "DISMINUIR")

            ' Agregar / acumular en el carrito
            AgregarProductoEnDetalle(nombre, precio, cantidad)

            ' Refrescar grilla del modal respetando el filtro actual
            cboTipoProducto_SelectedIndexChanged(sender, e)

            MostrarMensaje(lblMsgProducto, "'" & nombre & "' agregado a la venta.", True)

        Catch ex As Exception
            MostrarMensaje(lblMsgProducto, "Error al agregar el producto: " & ex.Message, False)
        End Try
    End Sub

    Private Sub AgregarProductoEnDetalle(ByVal nombre As String, ByVal precio As Decimal, ByVal cantidad As Integer)
        Dim dt As DataTable = GetDetalle()

        ' Si ya existe el producto → sumar cantidad
        For Each fila As DataRow In dt.Rows
            If fila("producto").ToString() = nombre Then
                fila("cantidad") = Convert.ToInt32(fila("cantidad")) + cantidad
                fila("subtotal") = Convert.ToDecimal(fila("precioVenta")) * Convert.ToInt32(fila("cantidad"))
                Session(KEY_DETALLE) = dt
                BindDetalle()
                Exit Sub
            End If
        Next

        ' Producto nuevo
        dt.Rows.Add(nombre, cantidad, precio, precio * cantidad)
        Session(KEY_DETALLE) = dt
        BindDetalle()
    End Sub

    '================================================================
    ' QUITAR PRODUCTO DEL DETALLE
    '   (faithful al escritorio: no repone el stock descontado)
    '================================================================
    Protected Sub dgvDetalle_RowCommand(ByVal sender As Object, ByVal e As GridViewCommandEventArgs)
        If e.CommandName <> "Quitar" Then Exit Sub

        Dim nombre As String = e.CommandArgument.ToString()
        Dim dt As DataTable = GetDetalle()
        For Each fila As DataRow In dt.Rows
            If fila("producto").ToString() = nombre Then
                fila.Delete()
                Exit For
            End If
        Next
        dt.AcceptChanges()
        Session(KEY_DETALLE) = dt
        BindDetalle()
    End Sub

    '================================================================
    ' GENERAR COMPROBANTE → abre el modal del comprobante
    '================================================================
    Protected Sub btnGenerar_Click(ByVal sender As Object, ByVal e As EventArgs)

        ' Validaciones (igual que el escritorio)
        If String.IsNullOrWhiteSpace(hdnClienteNombre.Value) Then
            MostrarMensaje(lblMensaje, "Seleccione un cliente de la lista.", False)
            Exit Sub
        End If

        If GetDetalle().Rows.Count = 0 Then
            MostrarMensaje(lblMensaje, "Agregue al menos un producto.", False)
            Exit Sub
        End If

        ' El comprobante busca al trabajador por su NOMBRE real (no por el usuario de login),
        ' guardado en Session("NombreTrabajador") al iniciar sesión.
        Dim trabajador As String = Convert.ToString(Session("NombreTrabajador"))
        If String.IsNullOrWhiteSpace(trabajador) Then
            MostrarMensaje(lblMensaje, "No se identificó al trabajador de la sesión. Inicie sesión nuevamente.", False)
            Exit Sub
        End If

        Try
            AbrirComprobante(trabajador)
        Catch ex As Exception
            MostrarMensaje(lblMensaje, "Error al abrir el comprobante: " & ex.Message, False)
        End Try
    End Sub

    '================================================================
    ' MODAL COMPROBANTE: cargar datos
    '================================================================
    Private Sub AbrirComprobante(ByVal trabajador As String)
        Dim tipoComprobante As String = cboTipoComprobante.SelectedValue
        Dim nombreCliente As String = hdnClienteNombre.Value

        ' DNI / RUC del cliente
        Dim dniRuc As String = ""
        Try
            dniRuc = objCliente.obtenerNumeroDocumento(nombreCliente)
        Catch
        End Try

        ' Encabezado
        lblTipoComp.Text = If(tipoComprobante.ToLower() = "factura", "FACTURA", "BOLETA DE VENTA")
        lblNumComp.Text = txtNumeroVenta.Text
        txtCompFecha.Text = Date.Now.ToString("yyyy-MM-dd")
        txtCompTrabajador.Text = trabajador
        txtCompCliente.Text = nombreCliente
        txtCompDniRuc.Text = dniRuc

        ' Detalle (desde el carrito)
        rptDetalleComp.DataSource = GetDetalle()
        rptDetalleComp.DataBind()

        ' Combos
        cboEstado.SelectedIndex = 0
        CargarMediosPago()

        ' Totales
        CalcularTotales()

        ' Estado inicial: botón imprimir bloqueado hasta guardar (igual que escritorio)
        btnImprimir.Enabled = False
        lblMsgComp.Visible = False
        ViewState("compGuardado") = False

        pnlModalComprobante.Visible = True
    End Sub

    Private Sub CargarMediosPago()
        Try
            Dim dt As DataTable = objComprobante.listarMedioPago()
            cboMedioPago.DataSource = dt
            cboMedioPago.DataTextField = "mediopago"
            cboMedioPago.DataValueField = "mediopago"
            cboMedioPago.DataBind()
        Catch
            cboMedioPago.DataSource = Nothing
            cboMedioPago.Items.Clear()
            cboMedioPago.Items.Add("Efectivo")
            cboMedioPago.Items.Add("Tarjeta de Crédito")
            cboMedioPago.Items.Add("Tarjeta de Débito")
            cboMedioPago.Items.Add("Transferencia")
        End Try

        ' Seleccionar "Efectivo" por defecto
        Dim item As ListItem = cboMedioPago.Items.FindByText("Efectivo")
        If item IsNot Nothing Then
            cboMedioPago.ClearSelection()
            item.Selected = True
        End If
        AplicarEstadoMonto()
    End Sub

    '================================================================
    ' TOTALES / IGV / SON  (base imponible = total / 1.18)
    '================================================================
    Private Sub CalcularTotales()
        Dim total As Decimal = 0
        For Each fila As DataRow In GetDetalle().Rows
            total += Convert.ToDecimal(fila("subtotal"))
        Next

        Dim baseImponible As Decimal = Math.Round(total / 1.18D, 2)
        Dim igv As Decimal = total - baseImponible

        txtSubTotal.Text = baseImponible.ToString("0.00")
        txtIgv.Text = igv.ToString("0.00")
        txtCompTotal.Text = total.ToString("0.00")

        Try
            lblSon.Text = objComprobante.numeroALetras(Convert.ToDouble(total))
        Catch
            lblSon.Text = ""
        End Try

        ' Si el medio no es efectivo, el monto = total
        If Not txtMonto.Enabled Then txtMonto.Text = txtCompTotal.Text
        CalcularVuelto()
    End Sub

    Protected Sub cboMedioPago_SelectedIndexChanged(ByVal sender As Object, ByVal e As EventArgs)
        AplicarEstadoMonto()
        pnlModalComprobante.Visible = True
    End Sub

    ' Habilita el monto sólo si el medio de pago es Efectivo
    Private Sub AplicarEstadoMonto()
        Dim esEfectivo As Boolean = (cboMedioPago.SelectedValue.Trim().ToLower() = "efectivo")
        txtMonto.Enabled = esEfectivo
        If Not esEfectivo Then
            txtMonto.Text = txtCompTotal.Text
        Else
            txtMonto.Text = ""
        End If
        CalcularVuelto()
    End Sub

    Protected Sub txtMonto_TextChanged(ByVal sender As Object, ByVal e As EventArgs)
        CalcularVuelto()
        pnlModalComprobante.Visible = True
    End Sub

    Private Sub CalcularVuelto()
        Dim monto As Decimal = 0
        Dim total As Decimal = 0
        Decimal.TryParse(txtMonto.Text, monto)
        Decimal.TryParse(txtCompTotal.Text, total)
        Dim vuelto As Decimal = monto - total
        txtVuelto.Text = If(vuelto >= 0, vuelto.ToString("0.00"), "0.00")
    End Sub

    '================================================================
    ' GUARDAR COMPROBANTE
    '================================================================
    Protected Sub btnGuardarComp_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlModalComprobante.Visible = True

        ' Validación
        Dim total As Decimal = 0, monto As Decimal = 0
        Decimal.TryParse(txtCompTotal.Text, total)
        Decimal.TryParse(txtMonto.Text, monto)

        If cboMedioPago.SelectedIndex < 0 Then
            MostrarMensaje(lblMsgComp, "Seleccione el medio de pago.", False)
            Exit Sub
        End If

        If cboEstado.SelectedValue = "Pagado" AndAlso monto < total Then
            MostrarMensaje(lblMsgComp, "El monto pagado no puede ser menor al total.", False)
            Exit Sub
        End If

        Try
            ' Construir lista de detalles {producto, cantidad(int), precio(single)}
            Dim detalles As New List(Of Object())()
            For Each fila As DataRow In GetDetalle().Rows
                detalles.Add(New Object() {
                    fila("producto").ToString(),
                    Convert.ToInt32(fila("cantidad")),
                    Convert.ToSingle(fila("precioVenta"))
                })
            Next

            Dim fecha As String = Date.Now.ToString("yyyy-MM-dd")
            Dim hora As String = Date.Now.ToString("HH:mm:ss")
            Dim tipoComprobante As String = cboTipoComprobante.SelectedValue

            objComprobante.transaccion(fecha, hora, txtNumeroVenta.Text, cboEstado.SelectedValue,
                                       tipoComprobante, 0, cboMedioPago.SelectedValue,
                                       txtCompTrabajador.Text, txtCompCliente.Text, detalles)

            MostrarMensaje(lblMsgComp, "Comprobante registrado correctamente. Ya puede imprimirlo o guardarlo en PDF.", True)

            ' Bloquear edición y habilitar impresión
            btnImprimir.Enabled = True
            btnGuardarComp.Enabled = False
            cboEstado.Enabled = False
            cboMedioPago.Enabled = False
            txtMonto.Enabled = False
            ViewState("compGuardado") = True

        Catch ex As Exception
            MostrarMensaje(lblMsgComp, "Error al guardar el comprobante: " & ex.Message, False)
        End Try
    End Sub

    Protected Sub btnCerrarComp_Click(ByVal sender As Object, ByVal e As EventArgs)
        pnlModalComprobante.Visible = False

        ' Si el comprobante se guardó, limpiar la venta para empezar una nueva
        If Convert.ToBoolean(If(ViewState("compGuardado"), False)) Then
            LimpiarVenta()
        End If
    End Sub

    '================================================================
    ' LIMPIAR DESPUÉS DE REGISTRAR
    '================================================================
    Private Sub LimpiarVenta()
        InicializarDetalle()
        BindDetalle()
        txtCliente.Text = ""
        hdnClienteNombre.Value = ""
        lblClienteSel.Text = "Ningún cliente seleccionado."
        cboTipoComprobante.SelectedIndex = 0
        CargarClientes()
        AutocompletarCabecera()

        ' Re-habilitar controles del comprobante para la próxima venta
        btnGuardarComp.Enabled = True
        cboEstado.Enabled = True
        cboMedioPago.Enabled = True
        ViewState("compGuardado") = False
    End Sub

    '================================================================
    ' HELPER DE MENSAJES
    '================================================================
    Private Sub MostrarMensaje(ByVal lbl As Label, ByVal mensaje As String, ByVal exito As Boolean)
        lbl.Visible = True
        lbl.CssClass = If(exito, "mensaje-exito", "mensaje-error")
        lbl.Text = mensaje
    End Sub

End Class
