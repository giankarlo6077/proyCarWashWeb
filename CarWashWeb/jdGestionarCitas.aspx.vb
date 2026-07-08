Imports System.Data
Imports com.somee.wspruebacarwash2
Partial Class jdGestionarCitas
    Inherits System.Web.UI.Page
    Dim objCita As New WSv1

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load

        txtBuscar.Attributes("oninput") = "dispararFiltro('" & txtBuscar.UniqueID & "')"

        If Not IsPostBack Then
            listarEmpleados()
            recargarGrilla()

            ' ─── LEER MENSAJE DE RETORNO ─────────────────────────────────
            Dim msg As String = Request.QueryString("msg")
            Select Case msg
                Case "ok"
                    MostrarMensaje("✔ Cita guardada correctamente con servicios agregados.", "green")
                Case "sinservicio"
                    MostrarMensaje("⚠ Cita guardada, pero no se agregó ningún servicio.", "orange")
            End Select

        End If
    End Sub

    Private Sub listarEmpleados()
        lblFecha.Text = DateTime.Now.ToString("dd/MM/yyyy")
        lblHora.Text = DateTime.Now.ToString("HH:mm:ss")

        cmbTrabajador.DataSource = objCita.listarTrabajadores()
        cmbTrabajador.DataTextField = "trabajador"
        cmbTrabajador.DataValueField = "idTrabajador"
        cmbTrabajador.DataBind()
    End Sub

    Private Sub recargarGrilla()
        FiltrarCitas(Nothing, Nothing)
    End Sub


    Protected Sub dgvCitas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "VerDetalle" Then
            Dim idCita As Integer = CInt(e.CommandArgument)
            Response.Redirect("jdDetalleOrdenTrabajo.aspx?idCita=" & idCita)
        End If
    End Sub

    Private Sub LimpiarControles()
        txtPlaca.Text = ""
        txtComentario.Text = ""
        dtpFechaRecojo.Text = ""
        lblNombreCliente.Text = "El nombre del cliente aparecerá aquí"
        lblNombreCliente.ForeColor = Drawing.Color.FromArgb(156, 163, 175)
        lblMensaje.Text = ""
        Session.Remove("dtServiciosCita")
        RefrescarGridServicios()
    End Sub

    Private Sub MostrarMensaje(texto As String, color As String)
        lblMensaje.Text = texto
        Select Case color
            Case "green" : lblMensaje.ForeColor = Drawing.Color.Green
            Case "orange" : lblMensaje.ForeColor = Drawing.Color.OrangeRed
            Case "red" : lblMensaje.ForeColor = Drawing.Color.Red
        End Select
    End Sub


    Protected Sub btnBuscarVehic_Click1(sender As Object, e As EventArgs) Handles btnBuscarVehic.Click
        If txtPlaca.Text.Trim() = "" Then
            lblNombreCliente.Text = "⚠ Ingrese una placa."
            Return
        End If

        Dim nombre As String = objCita.buscarPersonaPorPlaca(txtPlaca.Text.Trim())

        If nombre = "" Then
            lblNombreCliente.Text = "⚠ No se encontró cliente con esa placa."
        Else
            lblNombreCliente.Text = nombre
        End If
    End Sub

    Protected Sub btnLimpiar_Click1(sender As Object, e As EventArgs) Handles btnLimpiar.Click
        LimpiarControles()
    End Sub

    Protected Sub btnGenerarCita_Click1(sender As Object, e As EventArgs) Handles btnGenerarCita.Click
        Try
            If txtPlaca.Text.Trim() = "" OrElse dtpFechaRecojo.Text = "" Then
                MostrarMensaje("⚠ Complete todos los campos.", "orange")
                Return
            End If

            Dim idTrabajadorSeleccionado As Integer = CInt(cmbTrabajador.SelectedValue)
            Dim horaLimpia As New DateTime(DateTime.Now.Year, DateTime.Now.Month, DateTime.Now.Day,
                                       DateTime.Now.Hour, DateTime.Now.Minute, DateTime.Now.Second)
            Dim nuevoCodigo As Integer = CInt(objCita.generarCodigoCita)

            objCita.registrarCita(
            nuevoCodigo,
            DateTime.Now.Date,
            horaLimpia,
            txtComentario.Text,
            DateTime.Parse(dtpFechaRecojo.Text),
            objCita.buscarIDVehporPlaca(txtPlaca.Text.Trim()),
            idTrabajadorSeleccionado
        )

            ' Pasar los servicios seleccionados al detalle via Session
            ' (jdDetalleOrdenTrabajo los leerá en vez de cargar desde BD)
            If dtServiciosCita.Rows.Count > 0 Then
                Session("dtServiciosNuevaCita") = dtServiciosCita
            End If

            ' Limpiar session de esta página
            Session.Remove("dtServiciosCita")

            ' Ir al detalle para agregar más cosas si quiere
            Response.Redirect("jdDetalleOrdenTrabajo.aspx?idCita=" & nuevoCodigo)

        Catch ex As Exception
            MostrarMensaje("❌ Error: " & ex.Message, "red")
        End Try
    End Sub

    Protected Sub FiltrarCitas(sender As Object, e As EventArgs)
        Dim texto As String = txtBuscar.Text.Trim().ToLower()
        Dim periodo As String = ddlPeriodo.SelectedValue
        Dim dt As DataTable = objCita.listarCitas()

        ' Filtrar por período
        If periodo <> "" AndAlso dt.Rows.Count > 0 Then
            Dim fechaDesde As Date
            Select Case periodo
                Case "hoy" : fechaDesde = DateTime.Today
                Case "semana" : fechaDesde = DateTime.Today.AddDays(-7)
                Case "mes" : fechaDesde = DateTime.Today.AddMonths(-1)
                Case "anio" : fechaDesde = DateTime.Today.AddYears(-1)
            End Select

            Dim filas = dt.AsEnumerable().Where(Function(r)
                                                    Dim f As Date
                                                    Return Date.TryParse(r("fecha").ToString(), f) AndAlso f >= fechaDesde
                                                End Function)

            dt = If(filas.Any(), filas.CopyToDataTable(), dt.Clone())
        End If

        ' Filtrar por texto
        If texto <> "" AndAlso dt.Rows.Count > 0 Then
            Dim filas = dt.AsEnumerable().Where(Function(r)
                                                    Return r("placa").ToString().ToLower().Contains(texto) OrElse
                                                           r("comentario").ToString().ToLower().Contains(texto)
                                                End Function)

            dt = If(filas.Any(), filas.CopyToDataTable(), dt.Clone())
        End If

        dgvCitas.DataSource = dt
        dgvCitas.DataBind()
    End Sub

    Protected Sub btnLimpiarFiltro_Click(sender As Object, e As EventArgs)
        txtBuscar.Text = ""
        ddlPeriodo.SelectedIndex = 0
        recargarGrilla()
    End Sub


    ' ─── SESSION DE SERVICIOS TEMPORALES ─────────────────────────────────
    Private Property dtServiciosCita As DataTable
        Get
            If Session("dtServiciosCita") Is Nothing Then
                Dim dt As New DataTable()
                dt.Columns.Add("idServicio", GetType(Integer))
                dt.Columns.Add("servicio", GetType(String))
                Session("dtServiciosCita") = dt
            End If
            Return CType(Session("dtServiciosCita"), DataTable)
        End Get
        Set(value As DataTable)
            Session("dtServiciosCita") = value
        End Set
    End Property

    ' ─── REFRESCAR GRID DE SERVICIOS ─────────────────────────────────────
    Private Sub RefrescarGridServicios()
        dgvServiciosCita.DataSource = dtServiciosCita
        dgvServiciosCita.DataBind()
    End Sub

    ' ─── ABRIR MODAL ─────────────────────────────────────────────────────
    Protected Sub btnAgregarServicio_Click(sender As Object, e As EventArgs)
        dgvSelecServicios.DataSource = objCita.listarServicios()
        dgvSelecServicios.DataBind()
        hdnMostrarModalServicio.Value = "1"
    End Sub

    ' ─── SELECCIONAR SERVICIO DEL MODAL ──────────────────────────────────
    Protected Sub dgvSelecServicios_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "ElegirServicio" Then
            Dim idServicio As Integer = CInt(e.CommandArgument)

            ' Evitar duplicados
            Dim yaExiste = dtServiciosCita.AsEnumerable().Any(Function(r) CInt(r("idServicio")) = idServicio)
            If yaExiste Then
                ScriptManager.RegisterStartupScript(Me, Me.GetType(), "dup",
                    "alert('⚠ Este servicio ya fue agregado.');", True)
                hdnMostrarModalServicio.Value = "0"
                Return
            End If

            ' Obtener nombre del servicio
            Dim dtTodos As DataTable = objCita.listarServicios()
            Dim filaServ = dtTodos.AsEnumerable().FirstOrDefault(Function(r) CInt(r("idServicio")) = idServicio)

            Dim dr As DataRow = dtServiciosCita.NewRow()
            dr("idServicio") = idServicio
            dr("servicio") = If(filaServ IsNot Nothing, filaServ("servicio").ToString(), "")
            dtServiciosCita.Rows.Add(dr)
            Session("dtServiciosCita") = dtServiciosCita

            hdnMostrarModalServicio.Value = "0"
            RefrescarGridServicios()
        End If
    End Sub

    ' ─── CERRAR MODAL ────────────────────────────────────────────────────
    Protected Sub btnCerrarModalServicio_Click(sender As Object, e As EventArgs)
        hdnMostrarModalServicio.Value = "0"
    End Sub

    ' ─── QUITAR SERVICIO DEL GRID ────────────────────────────────────────
    Protected Sub dgvServiciosCita_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "QuitarServicio" Then
            Dim index As Integer = CInt(e.CommandArgument)
            Dim dt As DataTable = dtServiciosCita
            dt.Rows(index).Delete()
            dt.AcceptChanges()
            Session("dtServiciosCita") = dt
            RefrescarGridServicios()
        End If
    End Sub



End Class
