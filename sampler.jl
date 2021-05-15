### A Pluto.jl notebook ###
# v0.14.5

using Markdown
using InteractiveUtils

# ╔═╡ c8fb4baa-5a05-41b4-9d29-d3e314c94c2f
using Pkg

# ╔═╡ 24aafa54-b585-11eb-1663-014fcb679a76
Pkg.activate()

# ╔═╡ 692d83c5-ffb4-4b40-b989-3039952a9e37
Pkg.add([
	"FileIO",
	"VideoIO",
	"ImageShow",
	"ImageMagick",
	"ColorTypes",
	"FixedPointNumbers",
	"ImageTransformations"
])

# ╔═╡ 36cb387a-c18f-4991-a372-28b80a6b51a1
begin
	using FileIO
	using ImageShow
	using ColorTypes
	using VideoIO
	using FixedPointNumbers
	using ImageTransformations
end

# ╔═╡ 5df597c7-3c23-4b30-a57b-b3b343c0bbc9
resize_scale = 1/10

# ╔═╡ 82b38137-8a65-4074-8702-6a84eb17f0bd
source_file = "Bad Apple.mkv"

# ╔═╡ 098a1f39-fc55-4e2b-8ee3-80c447e64bc8
output_file = "sample.raw"

# ╔═╡ 4194db70-0a62-4225-bafb-6b94cdb2a3d6
begin
	video = load(source_file, target_format=VideoIO.AV_PIX_FMT_GRAY8)
	""
end

# ╔═╡ 054cb675-1b30-4d76-ad9b-8b678710808c
video_height, video_width = size(video[1])

# ╔═╡ bf2fcc6b-195e-45d5-b1b3-63ecc2952230
begin
	resized_video = imresize.(video, ratio = resize_scale)
	true
end

# ╔═╡ fdf55ef6-a340-4f56-acba-86f2cdc12ad6
function pixel_value_at(frame, i, j)
	reinterpret(resized_video[frame][i,j].val)
end

# ╔═╡ 84342635-9aa1-4b2d-8825-ae6cf3257512
output_height, output_width = size(video[1]) .* resize_scale .|> Int

# ╔═╡ edf8b475-5c9e-4683-a589-a1e84328409b
output_frame_count = size(video)[1]

# ╔═╡ e03ba2f2-653b-493a-aa0f-e0e1eb6b9fc5
begin
	sample = zeros(UInt8, 2 + output_frame_count * output_width * output_height)
	sample[1] = output_width
	sample[2] = output_height
end

# ╔═╡ e52536cb-0d77-4925-b3cd-2b4dd32f344a
for frame in 1:output_frame_count, i in 1:output_height, j in 1:output_width
	index = 2 + (frame - 1) * output_width * output_height + (i - 1) * output_width + j
	sample[index] = pixel_value_at(frame, i, j)
end

# ╔═╡ 55fe570c-cf16-47f1-96d6-fad1d4aa94c0
open(output_file, "w") do io
	write(io, sample)
end

# ╔═╡ Cell order:
# ╠═5df597c7-3c23-4b30-a57b-b3b343c0bbc9
# ╠═82b38137-8a65-4074-8702-6a84eb17f0bd
# ╠═098a1f39-fc55-4e2b-8ee3-80c447e64bc8
# ╟─c8fb4baa-5a05-41b4-9d29-d3e314c94c2f
# ╟─24aafa54-b585-11eb-1663-014fcb679a76
# ╟─692d83c5-ffb4-4b40-b989-3039952a9e37
# ╟─36cb387a-c18f-4991-a372-28b80a6b51a1
# ╟─4194db70-0a62-4225-bafb-6b94cdb2a3d6
# ╟─054cb675-1b30-4d76-ad9b-8b678710808c
# ╟─bf2fcc6b-195e-45d5-b1b3-63ecc2952230
# ╟─fdf55ef6-a340-4f56-acba-86f2cdc12ad6
# ╟─84342635-9aa1-4b2d-8825-ae6cf3257512
# ╟─edf8b475-5c9e-4683-a589-a1e84328409b
# ╟─e03ba2f2-653b-493a-aa0f-e0e1eb6b9fc5
# ╟─e52536cb-0d77-4925-b3cd-2b4dd32f344a
# ╟─55fe570c-cf16-47f1-96d6-fad1d4aa94c0
