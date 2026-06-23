Imports System.Data
Imports capaNegocio
Partial Class jdGestionarCitas
    Inherits System.Web.UI.Page
    Dim objCita As New clsCita()

    Protected Sub Page_Load(sender As Object, e As EventArgs) Handles Me.Load
        If Not IsPostBack Then
            listarEmpleados()
            recargarGrilla()
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
        dgvCitas.DataSource = objCita.listarCitas()
        dgvCitas.DataBind()
    End Sub


    Protected Sub dgvCitas_RowCommand(sender As Object, e As GridViewCommandEventArgs)
        If e.CommandName = "VerDetalle" Then
            Dim idCita As Integer = CInt(e.CommandArgument)
            Response.Redirect("DetalleOrdenTrabajo.aspx?idCita=" & idCita)
        End If
    End Sub

    Private Sub LimpiarControles()
        txtPlaca.Text = ""
        txtComentario.Text = ""
        dtpFechaRecojo.Text = ""
        lblNombreCliente.Text = ""
        lblMensaje.Text = ""
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

            objCita.registrarCita(
            CInt(objCita.generarCodigoCita),
            DateTime.Now.Date,
            horaLimpia,
            txtComentario.Text,
            DateTime.Parse(dtpFechaRecojo.Text),
            objCita.buscarIDVehporPlaca(txtPlaca.Text.Trim()),
            idTrabajadorSeleccionado
        )

            recargarGrilla()   ' <-- solo la grilla, no el combo
            LimpiarControles()
            MostrarMensaje("✔ Cita registrada correctamente.", "green")

        Catch ex As Exception
            MostrarMensaje("❌ Error: " & ex.Message, "red")
        End Try
    End Sub

End Class
