return {
	"vinnymeller/swagger-preview.nvim",
	keys = {
		desc = "Swagger preview toggle",
		ft = "",
	},
	cmd = { "SwaggerPreview", "SwaggerPreviewStop", "SwaggerPreviewToggle" },
	build = "npm i",
	config = true,
}
