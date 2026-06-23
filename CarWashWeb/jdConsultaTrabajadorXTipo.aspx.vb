Imports System.Data
Imports capaNegocio

Partial Class jdConsultaTrabajadorXTipo
    Inherits System.Web.UI.Page

    ' Instancias globales de conexión a tus clases de negocio referenciadas
    Dim objReporte As New clsReporteTrabajador()
    Dim objTipoTrabajador As New clsTipoTrabajador()

    Protected Sub Page_Load(ByVal sender As Object, ByVal e As EventArgs) Handles Me.Load
        ' Proteger la sesión de la plataforma Car Wash Web
        If Session("Usuario") Is Nothing Then
            Response.Redirect("jdInicioSesion.aspx")
            Exit Sub
        End If

        If Not Page.IsPostBack Then
            cargarTipos()
            ' Cargar todos al inicio tal como lo hace tu sub 'listarReporte()' en escritorio
            cargarDataGrid(todo:=True)
        End If
    End Sub

    '========================================
    ' CARGAR COMBOBOX
    '========================================
    Sub cargarTipos()
        Try
            Dim dt As DataTable = objTipoTrabajador.listarTipoTrabajador()
            cboTipoTrabajador.DataSource = dt
            cboTipoTrabajador.DataTextField = "tipoTrabajador"
            cboTipoTrabajador.DataValueField = "idTipoTrabajador"
            cboTipoTrabajador.DataBind()

            ' Index -1 de escritorio equivale a insertar un elemento neutro con valor "0"
            cboTipoTrabajador.Items.Insert(0, New ListItem("-- Seleccione un Tipo --", "0"))
        Catch ex As Exception
            MostrarError("Error al cargar los tipos de trabajadores: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' CARGAR Y FILTRAR REPORTE DINÁMICO
    '========================================
    Sub cargarDataGrid(ByVal todo As Boolean)
        Try
            lblMensaje.Text = ""
            Dim dt As DataTable

            ' Consumo de los métodos reales de tu clase especializada de reportes
            If todo OrElse cboTipoTrabajador.SelectedValue = "0" Then
                dt = objReporte.listarReporteTrabajador()
            Else
                Dim idTipo As Integer = Convert.ToInt32(cboTipoTrabajador.SelectedValue)
                dt = objReporte.filtrarTrabajadorPorTipo(idTipo)
            End If

            dgvTrabajadores.DataSource = dt
            dgvTrabajadores.DataBind()

            ' Renombrar estéticamente las cabeceras autogeneradas
            If dgvTrabajadores.Rows.Count > 0 Then
                dgvTrabajadores.HeaderRow.Cells(0).Text = "ID"
                dgvTrabajadores.HeaderRow.Cells(1).Text = "Trabajador"
                dgvTrabajadores.HeaderRow.Cells(2).Text = "DNI"
                dgvTrabajadores.HeaderRow.Cells(3).Text = "Tipo Trabajador"
                dgvTrabajadores.HeaderRow.Cells(4).Text = "Estado"
            End If

            ' Contador dinámico igual al de tu escritorio (.Rows.Count)
            If dt IsNot Nothing Then
                lblTotal.Text = "Total trabajadores: " & dt.Rows.Count.ToString()
            Else
                lblTotal.Text = "Total trabajadores: 0"
            End If

        Catch ex As Exception
            MostrarError("Error al procesar la consulta: " & ex.Message)
        End Try
    End Sub

    '========================================
    ' CONTROL DE ANCHOS Y ALINEACIONES CELDA POR CELDA
    '========================================
    Protected Sub dgvTrabajadores_RowDataBound(ByVal sender As Object, ByVal e As GridViewRowEventArgs)
        ' Modificar tanto la cabecera (Header) como las filas ordinarias (DataRow)
        If e.Row.RowType = DataControlRowType.Header OrElse e.Row.RowType = DataControlRowType.DataRow Then
            If e.Row.Cells.Count >= 5 Then
                ' Celda 0: ID (Fijo y compacto)
                e.Row.Cells(0).Width = Unit.Pixel(60)
                e.Row.Cells(0).HorizontalAlign = HorizontalAlign.Center

                ' Celda 1: Trabajador (No se toca, absorbe el resto del espacio flexible)

                ' Celda 2: DNI (Fijo)
                e.Row.Cells(2).Width = Unit.Pixel(120)

                ' Celda 3: Tipo Trabajador (Ajustado para corregir la separación masiva con Estado)
                e.Row.Cells(3).Width = Unit.Pixel(160)

                ' Celda 4: Estado (Compacto en la esquina derecha)
                e.Row.Cells(4).Width = Unit.Pixel(100)
                e.Row.Cells(4).HorizontalAlign = HorizontalAlign.Center
            End If
        End If
    End Sub

    '========================================
    ' ACCIONES DE BOTONES
    '========================================
    Protected Sub btnBuscar_Click(ByVal sender As Object, ByVal e As EventArgs)
        If cboTipoTrabajador.SelectedValue = "0" Then
            MostrarError("Seleccione un tipo trabajador")
            Exit Sub
        End If
        cargarDataGrid(todo:=False)
    End Sub

    Protected Sub btnMostrarTodos_Click(ByVal sender As Object, ByVal e As EventArgs)
        cboTipoTrabajador.SelectedIndex = 0
        cargarDataGrid(todo:=True)
    End Sub

    Protected Sub btnCerrar_Click(ByVal sender As Object, ByVal e As EventArgs)
        Response.Redirect("FrmMenuPrincipal.aspx")
    End Sub

    '========================================
    ' HELPERS MENSAJES
    '========================================
    Private Sub MostrarError(ByVal mensaje As String)
        lblMensaje.CssClass = "mensaje-error"
        lblMensaje.Text = mensaje
    End Sub
End Class