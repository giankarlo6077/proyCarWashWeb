Imports System.Globalization
Imports System.Runtime.CompilerServices
Imports com.somee.wspruebacarwash2

Partial Class FrmMenuPrincipal
    Inherits System.Web.UI.Page

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load

        ' Protegemos la página: si no hay sesión activa, regresa al login
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            ' Se refresca el nombre desde la BD por si fue modificado en Mantenimiento de Trabajadores
            Try
                Dim objTrabajadorNombre As New WSv1
                Dim nombreActual As String = objTrabajadorNombre.obtenerNombrePorUsuario(Convert.ToString(Session("Usuario")))
                If nombreActual <> "" Then
                    Session("NombreTrabajador") = nombreActual
                End If
            Catch ex As Exception
                ' Si falla el refresco, se sigue mostrando el último nombre conocido en sesión
            End Try

            lblNombreTrabajador.Text = Convert.ToString(Session("NombreTrabajador"))

            ' Fecha actual en español
            Dim culturaPeru As New CultureInfo("es-PE")
            Dim fechaTexto As String = Date.Now.ToString("dddd, dd 'de' MMMM 'de' yyyy", culturaPeru)
            lblFechaHoy.Text = Char.ToUpper(fechaTexto(0)) & fechaTexto.Substring(1)

            CargarResumen()
        End If

    End Sub

    Private Sub CargarResumen()
        Try
            Dim objDashboard As New WSv1

            lblTotalVentasHoy.Text = objDashboard.totalVentasHoy().ToString("N2")
            lblCantidadVentasHoy.Text = objDashboard.cantidadVentasHoy().ToString()
            lblCitasHoy.Text = objDashboard.citasHoy().ToString()
            lblCitasPendientes.Text = objDashboard.citasPendientes().ToString()
            lblTotalClientes.Text = objDashboard.totalClientes().ToString()

            dgvUltimasCitas.DataSource = objDashboard.ultimasCitas()
            dgvUltimasCitas.DataBind()

        Catch ex As Exception
            ' Si algo falla en el resumen, no rompemos toda la página
            lblTotalVentasHoy.Text = "0.00"
        End Try
    End Sub

    ' ─────────────────────────────────────────────
    '  GENERA EL BADGE DE COLOR SEGÚN EL ESTADO DE LA CITA
    ' ─────────────────────────────────────────────
    Protected Function ObtenerBadgeEstado(ByVal estado As String) As String
        Dim claseCss As String

        Select Case estado.ToLower()
            Case "pendiente"
                claseCss = "badge-pendiente"
            Case "completado", "completada", "atendido", "atendida"
                claseCss = "badge-completado"
            Case "cancelado", "cancelada"
                claseCss = "badge-cancelado"
            Case Else
                claseCss = "badge-otro"
        End Select

        Return "<span class='badge-estado " & claseCss & "'>" & estado & "</span>"
    End Function


    Protected Sub btnCerrarCitas_Click(sender As Object, e As EventArgs) Handles btnCerrarCitas.Click
        Try

            Dim objCerrarCita As New WSAdi.WebService1SoapClient("WebService1Soap")

            objCerrarCita.cancelarCitaVencida()

            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('¡Las citas vencidas han sido cerradas correctamente!');", True)
        Catch ex As Exception
            ScriptManager.RegisterStartupScript(Me, Me.GetType(), "alert", "alert('Error al conectar con el Web Service: " & ex.Message.Replace("'", "\'") & "');", True)
        End Try
    End Sub
End Class