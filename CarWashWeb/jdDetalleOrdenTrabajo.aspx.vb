Imports System.Data
Imports System.Globalization
Imports capaNegocio
Partial Class jdDetalleOrdenTrabajo
    Inherits System.Web.UI.Page

    Dim objCita As New clsCita
    Private _idCita As Integer

    ' ─── PROPIEDADES DE SESSION ──────────────────────────────────────────
    Private Property dtServicios As DataTable
        Get
            If Session("dtServicios") Is Nothing Then
                Dim dt As New DataTable()
                dt.Columns.Add("idServicio", GetType(Integer))
                dt.Columns.Add("servicio", GetType(String))
                Session("dtServicios") = dt
            End If
            Return CType(Session("dtServicios"), DataTable)
        End Get
        Set(value As DataTable)
            Session("dtServicios") = value
        End Set
    End Property

    Private Property dtProductos As DataTable
        Get
            If Session("dtProductos") Is Nothing Then
                Dim dt As New DataTable()
                dt.Columns.Add("idProducto", GetType(Integer))
                dt.Columns.Add("producto", GetType(String))
                dt.Columns.Add("precio", GetType(Double))
                Session("dtProductos") = dt
            End If
            Return CType(Session("dtProductos"), DataTable)
        End Get
        Set(value As DataTable)
            Session("dtProductos") = value
        End Set
    End Property

    ' ─── PAGE LOAD ───────────────────────────────────────────────────────
    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Request.QueryString("idCita") Is Nothing Then
            Response.Redirect("jdGestionarCitas.aspx")
            Return
        End If

        _idCita = CInt(Request.QueryString("idCita"))

        If Not IsPostBack Then
            hdnIdCita.Value = _idCita.ToString()        ' - guardar en hidden
            Session.Remove("dtServicios")
            Session.Remove("dtProductos")
            CargarDatosCita()
            CargarComboTrabajador()
            ' Solo refrescar en la primera carga
            RefrescarGridServicios()
            RefrescarGridProductos()
        Else
            _idCita = CInt(hdnIdCita.Value)             ' - recuperar en postback
            ' NO refrescar aquí — cada evento lo hará después
        End If

    End Sub

    ' ─── CARGA DE DATOS ──────────────────────────────────────────────────
    Private Sub CargarDatosCita()
        Dim fila As DataRow = objCita.cargarDatosCita(_idCita)

        If fila Is Nothing Then
            MostrarMensaje("⚠ No se encontró la cita.", "red")
            Return
        End If

        lblidCita.Text = fila("idCita").ToString()
        lblFecha.Text = CDate(fila("fecha")).ToString("dd/MM/yyyy")
        lblHora.Text = fila("hora").ToString()
        lblPlaca.Text = fila("placa").ToString()
        lblModelo.Text = fila("modeloVehiculo").ToString()
        lblAno.Text = fila("anoFabricacion").ToString()
        lblCliente.Text = fila("cliente").ToString()
        lblTelefono.Text = fila("telefono").ToString()

        txtComentario.Text = fila("comentario").ToString()
        dtpFechaRecojo.Text = CDate(fila("fechaRecojo")).ToString("yyyy-MM-dd")

        ' Estado
        cmbEstado.ClearSelection()
        Dim itemEstado = cmbEstado.Items.FindByValue(fila("estado").ToString())
        If itemEstado IsNot Nothing Then itemEstado.Selected = True

        ' Cargar servicios y productos actuales de la cita en Session
        dtServicios = objCita.cargarServiciosdelaCita(_idCita)
        dtProductos = objCita.cargarProductosdelaCita(_idCita)
    End Sub

    Private Sub CargarComboTrabajador()
        cmbTrabajador.DataSource = objCita.listarTrabajadores()
        cmbTrabajador.DataTextField = "trabajador"
        cmbTrabajador.DataValueField = "idTrabajador"
        cmbTrabajador.DataBind()

        ' Seleccionar el trabajador asignado a la cita
        Dim fila As DataRow = objCita.cargarDatosCita(_idCita)
        If fila IsNot Nothing Then
            Dim item = cmbTrabajador.Items.FindByText(fila("trabajador").ToString())
            If item IsNot Nothing Then item.Selected = True
        End If
    End Sub

    Private Sub RefrescarGridServicios()
        dgvServicios.DataSource = dtServicios
        dgvServicios.DataBind()
    End Sub

    Private Sub RefrescarGridProductos()
        dgvProductos.DataSource = dtProductos
        dgvProductos.DataBind()
    End Sub

    ' ─── MODAL SERVICIOS ─────────────────────────────────────────────────
    Protected Sub btnAgregarServicio_Click(sender As Object, e As EventArgs)
        dgvSelecServicios.DataSource = objCita.listarServicios()
        dgvSelecServicios.DataBind()
        hdnMostrarModalServicio.Value = "1"
    End Sub

    Protected Sub dgvSelecServicios_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ElegirServicio" Then
            Dim idServicio As Integer = CInt(e.CommandArgument)

            ' Validar disponibilidad para el tipo de vehículo
            Dim idTipoVehiculo As Integer = objCita.obtenerIdTipoVehiculo(_idCita)
            Dim precio As Double = objCita.obtenerPrecioServicio(idServicio, idTipoVehiculo)

            If precio = 0 Then
                ' Mostrar alert como en escritorio
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alerta",
                "alert('⚠ Este servicio no está disponible para el tipo de vehículo de esta cita.');", True)
                hdnMostrarModalServicio.Value = "0"
                Return
            End If

            ' Evitar duplicados
            Dim yaExiste = dtServicios.AsEnumerable().Any(Function(r) CInt(r("idServicio")) = idServicio)
            If yaExiste Then
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alerta",
                "alert('⚠ Este servicio ya fue agregado.');", True)
                hdnMostrarModalServicio.Value = "0"
                Return
            End If

            ' Obtener nombre del servicio
            Dim dt As DataTable = objCita.listarServicios()
            Dim filaServ = dt.AsEnumerable().FirstOrDefault(Function(r) CInt(r("idServicio")) = idServicio)

            Dim dr As DataRow = dtServicios.NewRow()
            dr("idServicio") = idServicio
            dr("servicio") = If(filaServ IsNot Nothing, filaServ("servicio").ToString(), "")
            dtServicios.Rows.Add(dr)
            Session("dtServicios") = dtServicios

            hdnMostrarModalServicio.Value = "0"
            RefrescarGridServicios()
        End If
    End Sub

    Protected Sub btnCerrarModalServicio_Click(sender As Object, e As EventArgs)
        hdnMostrarModalServicio.Value = "0"
    End Sub

    ' ─── MODAL PRODUCTOS ─────────────────────────────────────────────────
    Protected Sub btnAgregarProducto_Click(sender As Object, e As EventArgs)
        dgvSelecProductos.DataSource = objCita.listarProductos()
        dgvSelecProductos.DataBind()
        hdnMostrarModalProducto.Value = "1"
    End Sub

    Protected Sub dgvSelecProductos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ElegirProducto" Then
            Dim idProducto As Integer = CInt(e.CommandArgument)

            Dim dt As DataTable = objCita.listarProductos()
            Dim filaProd = dt.AsEnumerable().FirstOrDefault(Function(r) CInt(r("idProducto")) = idProducto)

            If filaProd Is Nothing Then Return

            Dim dr As DataRow = dtProductos.NewRow()
            dr("idProducto") = idProducto
            dr("producto") = filaProd("producto").ToString()
            dr("precio") = CDbl(filaProd("precio"))
            dtProductos.Rows.Add(dr)
            Session("dtProductos") = dtProductos

            hdnMostrarModalProducto.Value = "0"
            RefrescarGridProductos()
        End If
    End Sub

    Protected Sub btnCerrarModalProducto_Click(sender As Object, e As EventArgs)
        hdnMostrarModalProducto.Value = "0"
    End Sub

    ' ─── QUITAR FILAS DE LOS GRIDS ───────────────────────────────────────
    Protected Sub dgvServicios_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "QuitarServicio" Then
            Dim index As Integer = CInt(e.CommandArgument)
            Dim dt As DataTable = dtServicios
            dt.Rows(index).Delete()
            dt.AcceptChanges()
            Session("dtServicios") = dt
            RefrescarGridServicios()  ' ← ahora sí se muestra actualizado
        End If
    End Sub

    Protected Sub dgvProductos_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "QuitarProducto" Then
            Dim index As Integer = CInt(e.CommandArgument)
            Dim dt As DataTable = dtProductos
            dt.Rows(index).Delete()
            dt.AcceptChanges()
            Session("dtProductos") = dt
            RefrescarGridProductos()  ' ← ahora sí se muestra actualizado
        End If
    End Sub

    ' ─── GUARDAR ─────────────────────────────────────────────────────────
    Protected Sub btnGuardar_Click(sender As Object, e As EventArgs)
        Try
            If cmbEstado.SelectedIndex = -1 Then
                MostrarMensaje("⚠ Seleccione un estado.", "orange") : Return
            End If

            _idCita = CInt(lblidCita.Text)

            Dim fec As Date = Date.ParseExact(lblFecha.Text, "dd/MM/yyyy", CultureInfo.InvariantCulture)
            Dim hor As Date = Date.ParseExact(lblHora.Text, "HH:mm:ss", CultureInfo.InvariantCulture)
            Dim estado As String = cmbEstado.SelectedValue
            Dim coment As String = txtComentario.Text.Trim()
            Dim fechRec As Date = DateTime.Parse(dtpFechaRecojo.Text)
            Dim idVeh As Integer = objCita.buscarIDVehporPlaca(lblPlaca.Text)
            Dim idTrab As Integer = CInt(cmbTrabajador.SelectedValue)

            objCita.modificarCita(_idCita, fec, hor, estado, coment, fechRec, idVeh, idTrab)

            Dim idTipoVehiculo As Integer = objCita.obtenerIdTipoVehiculo(_idCita)

            ' Eliminar anteriores
            objCita.eliminarServiciosdeCita(_idCita)
            objCita.eliminarProductosdeCita(_idCita)

            ' Guardar servicios
            For Each fila As DataRow In dtServicios.Rows
                Dim idServicio As Integer = CInt(fila("idServicio"))
                Dim precioVenta As Double = objCita.obtenerPrecioServicio(idServicio, idTipoVehiculo)
                If precioVenta > 0 Then
                    objCita.registrarServicioparaCita(precioVenta, _idCita, idTipoVehiculo, idServicio)
                End If
            Next

            ' Guardar productos
            Dim cantidadTotal As Integer = dtProductos.Rows.Count
            For Each fila As DataRow In dtProductos.Rows
                Dim idProducto As Integer = CInt(fila("idProducto"))
                Dim precio As Double = CDbl(fila("precio"))
                objCita.registrarProductoparaCita(cantidadTotal, precio, _idCita, idProducto)
            Next

            ' Limpiar session y volver
            Session.Remove("dtServicios")
            Session.Remove("dtProductos")
            Response.Redirect("jdGestionarCitas.aspx")

        Catch ex As Exception
            MostrarMensaje("❌ Error: " & ex.Message, "red")
        End Try
    End Sub

    ' ─── CANCELAR / VOLVER ───────────────────────────────────────────────
    Protected Sub btnCancelar_Click(sender As Object, e As EventArgs)
        Session.Remove("dtServicios")
        Session.Remove("dtProductos")
        Response.Redirect("jdGestionarCitas.aspx")
    End Sub

    Protected Sub btnVolver_Click(sender As Object, e As EventArgs)
        Session.Remove("dtServicios")
        Session.Remove("dtProductos")
        Response.Redirect("jdGestionarCitas.aspx")
    End Sub

    ' ─── HELPER MENSAJES ─────────────────────────────────────────────────
    Private Sub MostrarMensaje(texto As String, color As String)
        lblMensaje.Text = texto
        Select Case color
            Case "green" : lblMensaje.ForeColor = Drawing.Color.Green
            Case "orange" : lblMensaje.ForeColor = Drawing.Color.OrangeRed
            Case "red" : lblMensaje.ForeColor = Drawing.Color.Red
        End Select
    End Sub

End Class
