#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Ghép nguồn Markdown trong docs/bao_cao/ thành tệp DOCX nộp bài.

Cách dùng (từ thư mục gốc repo):
    python docs/build_bao_cao.py

Nguồn:  docs/bao_cao/*.md  (ghép theo thứ tự tên tệp)
Đích:   docs/N24DCDT022_DT011_TranHuuDuy_BaoCao.docx

Cú pháp Markdown được hỗ trợ (tập con, đủ cho báo cáo):
    # H1 / ## H2 / ### H3      tiêu đề chương, mục, tiểu mục
    | a | b |                   bảng, dòng đầu là tiêu đề cột
    ``` ... ```                 khối mã
    - mục                       gạch đầu dòng
    > ghi chú                   đoạn ghi chú in nghiêng, thụt lề
    Bảng 1.1 ...                chú thích bảng (in đậm, canh giữa)
    ![Hình 4.1 ...](đường dẫn)  chèn ảnh kèm chú thích
    [[PAGEBREAK]]               ngắt trang
    [[TOC]]                     mục lục tự động (cập nhật bằng F9 trong Word)
    ::: bia ... :::             trang bìa, mỗi dòng có tiền tố [s14,b] ...

Chữ đậm **như này**, chữ nghiêng *như này*, mã `như này`.
"""

from __future__ import annotations

import re
import sys
from pathlib import Path

if hasattr(sys.stdout, "reconfigure"):
    sys.stdout.reconfigure(encoding="utf-8", errors="replace")

from docx import Document
from docx.enum.section import WD_SECTION
from docx.enum.table import WD_ALIGN_VERTICAL, WD_TABLE_ALIGNMENT
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_BREAK, WD_LINE_SPACING
from docx.oxml import OxmlElement
from docx.oxml.ns import qn
from docx.shared import Cm, Pt, RGBColor

ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = ROOT / "docs" / "bao_cao"
OUT_DOCX = ROOT / "docs" / "N24DCDT022_DT011_TranHuuDuy_BaoCao.docx"

FONT_BODY = "Times New Roman"
FONT_CODE = "Consolas"
SIZE_BODY = 13
SIZE_TABLE = 10.5
SIZE_CAPTION = 11

HEADER_TEXT = "Báo cáo đồ án INT13185 — Trần Hữu Duy — N24DCDT022 — DT011"


# --------------------------------------------------------------------------
# Tiện ích cấp thấp
# --------------------------------------------------------------------------
def set_run_font(run, name=FONT_BODY, size=None, bold=None, italic=None, color=None):
    run.font.name = name
    rpr = run._element.get_or_add_rPr()
    rfonts = rpr.find(qn("w:rFonts"))
    if rfonts is None:
        rfonts = OxmlElement("w:rFonts")
        rpr.append(rfonts)
    for attr in ("w:ascii", "w:hAnsi", "w:cs", "w:eastAsia"):
        rfonts.set(qn(attr), name)
    if size is not None:
        run.font.size = Pt(size)
    if bold is not None:
        run.bold = bold
    if italic is not None:
        run.italic = italic
    if color is not None:
        run.font.color.rgb = color


def shade(element, fill):
    """Tô nền cho đoạn văn hoặc ô bảng."""
    pr = element.get_or_add_tcPr() if element.tag.endswith("tc") else element.get_or_add_pPr()
    shd = OxmlElement("w:shd")
    shd.set(qn("w:val"), "clear")
    shd.set(qn("w:color"), "auto")
    shd.set(qn("w:fill"), fill)
    pr.append(shd)


def add_field(paragraph, instruction, placeholder=""):
    """Chèn field Word (ví dụ PAGE, TOC)."""
    run = paragraph.add_run()
    begin = OxmlElement("w:fldChar")
    begin.set(qn("w:fldCharType"), "begin")
    instr = OxmlElement("w:instrText")
    instr.set(qn("xml:space"), "preserve")
    instr.text = instruction
    separate = OxmlElement("w:fldChar")
    separate.set(qn("w:fldCharType"), "separate")
    end = OxmlElement("w:fldChar")
    end.set(qn("w:fldCharType"), "end")
    run._r.append(begin)
    run._r.append(instr)
    run._r.append(separate)
    if placeholder:
        run.add_text(placeholder)
    run._r.append(end)
    return run


def keep_with_next(paragraph, value=True):
    paragraph.paragraph_format.keep_with_next = value


# --------------------------------------------------------------------------
# Định dạng văn bản nội tuyến: **đậm**, *nghiêng*, `mã`
# --------------------------------------------------------------------------
INLINE_RE = re.compile(r"(\*\*.+?\*\*|`[^`]+`|\*[^*]+?\*)")


def add_inline(paragraph, text, size=SIZE_BODY, bold=False, italic=False, name=FONT_BODY):
    for piece in INLINE_RE.split(text):
        if not piece:
            continue
        if piece.startswith("**") and piece.endswith("**") and len(piece) > 4:
            run = paragraph.add_run(piece[2:-2])
            set_run_font(run, name, size, bold=True, italic=italic)
        elif piece.startswith("`") and piece.endswith("`") and len(piece) > 2:
            run = paragraph.add_run(piece[1:-1])
            set_run_font(run, FONT_CODE, size - 1.5, bold=bold, italic=False)
        elif piece.startswith("*") and piece.endswith("*") and len(piece) > 2:
            run = paragraph.add_run(piece[1:-1])
            set_run_font(run, name, size, bold=bold, italic=True)
        else:
            run = paragraph.add_run(piece)
            set_run_font(run, name, size, bold=bold, italic=italic)


# --------------------------------------------------------------------------
# Document va kiểu
# --------------------------------------------------------------------------
def setup_document():
    doc = Document()

    section = doc.sections[0]
    section.page_width = Cm(21.0)
    section.page_height = Cm(29.7)
    section.top_margin = Cm(2.5)
    section.bottom_margin = Cm(2.5)
    section.left_margin = Cm(3.0)
    section.right_margin = Cm(2.0)
    section.header_distance = Cm(1.2)
    section.footer_distance = Cm(1.2)
    section.different_first_page_header_footer = True  # bìa không có header/footer

    normal = doc.styles["Normal"]
    normal.font.name = FONT_BODY
    normal.font.size = Pt(SIZE_BODY)
    normal.element.rPr.rFonts.set(qn("w:eastAsia"), FONT_BODY)
    pf = normal.paragraph_format
    pf.line_spacing = 1.25
    pf.space_after = Pt(4)
    pf.space_before = Pt(0)
    pf.alignment = WD_ALIGN_PARAGRAPH.JUSTIFY

    specs = {
        "Heading 1": (16, True, WD_ALIGN_PARAGRAPH.CENTER, 0, 14),
        "Heading 2": (14, True, WD_ALIGN_PARAGRAPH.LEFT, 12, 6),
        "Heading 3": (13, True, WD_ALIGN_PARAGRAPH.LEFT, 10, 4),
    }
    for name, (size, bold, align, before, after) in specs.items():
        st = doc.styles[name]
        st.font.name = FONT_BODY
        st.font.size = Pt(size)
        st.font.bold = bold
        st.font.color.rgb = RGBColor(0, 0, 0)
        st.element.rPr.rFonts.set(qn("w:eastAsia"), FONT_BODY)
        st.paragraph_format.alignment = align
        st.paragraph_format.space_before = Pt(before)
        st.paragraph_format.space_after = Pt(after)
        st.paragraph_format.line_spacing = 1.2
        st.paragraph_format.keep_with_next = True

    # Header
    header = section.header
    hp = header.paragraphs[0]
    hp.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    hr = hp.add_run(HEADER_TEXT)
    set_run_font(hr, FONT_BODY, 9, italic=True, color=RGBColor(0x55, 0x55, 0x55))

    # Footer: "Trang N"
    footer = section.footer
    fp = footer.paragraphs[0]
    fp.alignment = WD_ALIGN_PARAGRAPH.CENTER
    r1 = fp.add_run("Trang ")
    set_run_font(r1, FONT_BODY, 10)
    add_field(fp, "PAGE", "1")

    return doc


# --------------------------------------------------------------------------
# Các khối nội dung
# --------------------------------------------------------------------------
def add_heading(doc, text, level, first_block=False):
    p = doc.add_paragraph(style=f"Heading {level}")
    if level == 1 and not first_block:
        p.paragraph_format.page_break_before = True
    run = p.add_run(text.strip())
    set_run_font(run, FONT_BODY, {1: 16, 2: 14, 3: 13}[level], bold=True)
    return p


def add_paragraph(doc, text):
    p = doc.add_paragraph()
    p.paragraph_format.first_line_indent = Cm(1.0)
    add_inline(p, text)
    return p


def add_bullet(doc, text):
    p = doc.add_paragraph()
    pf = p.paragraph_format
    pf.left_indent = Cm(1.0)
    pf.first_line_indent = Cm(-0.4)
    pf.space_after = Pt(3)
    add_inline(p, "• " + text)
    return p


def add_note(doc, text):
    p = doc.add_paragraph()
    pf = p.paragraph_format
    pf.left_indent = Cm(0.8)
    pf.right_indent = Cm(0.5)
    pf.space_before = Pt(6)
    pf.space_after = Pt(6)
    add_inline(p, text, size=SIZE_BODY - 0.5, italic=True)
    return p


def add_caption(doc, text):
    p = doc.add_paragraph()
    pf = p.paragraph_format
    pf.alignment = WD_ALIGN_PARAGRAPH.CENTER
    pf.space_before = Pt(10)
    pf.space_after = Pt(4)
    pf.first_line_indent = Cm(0)
    pf.keep_with_next = True
    run = p.add_run(text.strip())
    set_run_font(run, FONT_BODY, SIZE_CAPTION, bold=True)
    return p


def add_code(doc, lines):
    p = doc.add_paragraph()
    pf = p.paragraph_format
    pf.left_indent = Cm(0.6)
    pf.space_before = Pt(4)
    pf.space_after = Pt(8)
    pf.line_spacing = 1.0
    pf.alignment = WD_ALIGN_PARAGRAPH.LEFT
    shade(p._p, "F4F4F4")
    for i, line in enumerate(lines):
        run = p.add_run(line)
        set_run_font(run, FONT_CODE, 10)
        if i < len(lines) - 1:
            run.add_break(WD_BREAK.LINE)
    return p


def add_table(doc, rows):
    n_cols = max(len(r) for r in rows)
    rows = [r + [""] * (n_cols - len(r)) for r in rows]
    table = doc.add_table(rows=len(rows), cols=n_cols)
    table.style = "Table Grid"
    table.alignment = WD_TABLE_ALIGNMENT.CENTER
    table.autofit = False

    # bề rộng cột theo độ dài nội dung, giới hạn để cột không quá hẹp
    usable = 16.0  # cm (A4 trừ lề 3 + 2)
    weights = []
    for c in range(n_cols):
        longest = max(len(r[c]) for r in rows)
        weights.append(min(max(longest, 10), 46) + 6.0)
    total = sum(weights)
    widths = [max(usable * w / total, usable * 0.11) for w in weights]
    scale = usable / sum(widths)
    widths = [w * scale for w in widths]

    for c, w in enumerate(widths):
        table.columns[c].width = Cm(w)

    for r_idx, row in enumerate(rows):
        for c_idx, text in enumerate(row):
            cell = table.cell(r_idx, c_idx)
            cell.width = Cm(widths[c_idx])
            cell.vertical_alignment = WD_ALIGN_VERTICAL.CENTER
            cell.text = ""
            p = cell.paragraphs[0]
            pf = p.paragraph_format
            pf.space_before = Pt(2)
            pf.space_after = Pt(2)
            pf.line_spacing = 1.05
            pf.alignment = (
                WD_ALIGN_PARAGRAPH.CENTER if (r_idx == 0 or len(text) <= 8)
                else WD_ALIGN_PARAGRAPH.LEFT
            )
            # giữ cả bảng trên một trang: mọi dòng trừ dòng cuối nối với dòng sau
            if r_idx < len(rows) - 1:
                pf.keep_with_next = True
            add_inline(p, text, size=SIZE_TABLE, bold=(r_idx == 0))
            if r_idx == 0:
                shade(cell._tc, "E7E6E6")

    # không cho một dòng bị cắt đôi giữa hai trang
    for row in table.rows:
        trPr = row._tr.get_or_add_trPr()
        cant_split = OxmlElement("w:cantSplit")
        trPr.append(cant_split)

    # lặp dòng tiêu đề khi bảng sang trang
    tr = table.rows[0]._tr
    trPr = tr.get_or_add_trPr()
    tblHeader = OxmlElement("w:tblHeader")
    tblHeader.set(qn("w:val"), "true")
    trPr.append(tblHeader)

    doc.add_paragraph().paragraph_format.space_after = Pt(2)
    return table


def add_image(doc, path, caption):
    full = (ROOT / path).resolve()
    if not full.exists():
        p = doc.add_paragraph()
        add_inline(p, f"[thiếu ảnh: {path}]", italic=True)
        return
    p = doc.add_paragraph()
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p.paragraph_format.space_before = Pt(6)
    p.paragraph_format.space_after = Pt(2)
    p.add_run().add_picture(str(full), width=Cm(15.5))
    if caption:
        cp = doc.add_paragraph()
        cp.alignment = WD_ALIGN_PARAGRAPH.CENTER
        cp.paragraph_format.space_after = Pt(10)
        run = cp.add_run(caption)
        set_run_font(run, FONT_BODY, SIZE_CAPTION, italic=True)


def add_cover(doc, lines):
    """Trang bìa: mỗi dòng có tiền tố [s14,b] (cỡ chữ, đậm)."""
    for _ in range(2):
        sp = doc.add_paragraph()
        sp.paragraph_format.space_after = Pt(0)
    for raw in lines:
        if not raw.strip():
            doc.add_paragraph().paragraph_format.space_after = Pt(0)
            continue
        size, bold, text = 13.0, True, raw
        m = re.match(r"^\[([^\]]*)\]\s*(.*)$", raw)
        if m:
            opts, text = m.group(1), m.group(2)
            for opt in opts.split(","):
                opt = opt.strip()
                if opt.startswith("s"):
                    size = float(opt[1:])
                elif opt == "b":
                    bold = True
                elif opt == "n":
                    bold = False
        p = doc.add_paragraph()
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        p.paragraph_format.space_after = Pt(6)
        p.paragraph_format.line_spacing = 1.15
        run = p.add_run(text)
        set_run_font(run, FONT_BODY, size, bold=bold)


# --------------------------------------------------------------------------
# Bộ phân tích Markdown
# --------------------------------------------------------------------------
def parse_blocks(text):
    """Tách văn bản thành danh sách (loại, nội dung)."""
    blocks = []
    lines = text.splitlines()
    i = 0
    while i < len(lines):
        line = lines[i]
        stripped = line.strip()

        if not stripped:
            i += 1
            continue

        # khối bìa
        if stripped == "::: bia":
            i += 1
            buf = []
            while i < len(lines) and lines[i].strip() != ":::":
                buf.append(lines[i])
                i += 1
            i += 1
            blocks.append(("cover", buf))
            continue

        if stripped.startswith("```"):
            i += 1
            buf = []
            while i < len(lines) and not lines[i].strip().startswith("```"):
                buf.append(lines[i])
                i += 1
            i += 1
            blocks.append(("code", buf))
            continue

        if stripped == "[[PAGEBREAK]]":
            blocks.append(("pagebreak", None))
            i += 1
            continue

        if stripped == "[[TOC]]":
            blocks.append(("toc", None))
            i += 1
            continue

        # bảng: các dòng liên tiếp bắt đầu bằng |
        if stripped.startswith("|"):
            buf = []
            while i < len(lines) and lines[i].strip().startswith("|"):
                row = lines[i].strip()
                if not re.fullmatch(r"\|[\s:\-|]+\|", row):
                    # "\|" cho phép dấu gạch đứng trong ô (ví dụ |a[i]|)
                    row = row.replace("\\|", "\x01")
                    cells = [c.replace("\x01", "|").strip() for c in row.strip("|").split("|")]
                    buf.append(cells)
                i += 1
            blocks.append(("table", buf))
            continue

        m = re.match(r"^(#{1,3})\s+(.*)$", stripped)
        if m:
            blocks.append(("h%d" % len(m.group(1)), m.group(2)))
            i += 1
            continue

        if stripped.startswith("> "):
            blocks.append(("note", stripped[2:]))
            i += 1
            continue

        if re.match(r"^[-*]\s+", stripped):
            blocks.append(("bullet", re.sub(r"^[-*]\s+", "", stripped)))
            i += 1
            continue

        img = re.match(r"^!\[(.*?)\]\((.*?)\)$", stripped)
        if img:
            blocks.append(("image", (img.group(2), img.group(1))))
            i += 1
            continue

        if re.match(r"^(Bảng|Hình)\s", stripped):
            blocks.append(("caption", stripped))
            i += 1
            continue

        # đoạn văn: gộp các dòng liền nhau
        buf = [stripped]
        i += 1
        while i < len(lines):
            nxt = lines[i].strip()
            if (not nxt or nxt.startswith(("|", "```", "#", "> ", "- ", "* "))
                    or re.match(r"^!\[", nxt) or nxt in ("[[PAGEBREAK]]", "[[TOC]]", "::: bia")):
                break
            buf.append(nxt)
            i += 1
        blocks.append(("p", " ".join(buf)))

    return blocks


def build():
    if not SRC_DIR.exists():
        sys.exit(f"Không thấy thư mục nguồn: {SRC_DIR}")

    sources = sorted(SRC_DIR.glob("*.md"))
    if not sources:
        sys.exit(f"Không có tệp .md nào trong {SRC_DIR}")

    doc = setup_document()
    first_block = True

    for src in sources:
        for kind, payload in parse_blocks(src.read_text(encoding="utf-8")):
            if kind == "cover":
                add_cover(doc, payload)
            elif kind in ("h1", "h2", "h3"):
                add_heading(doc, payload, int(kind[1]), first_block)
            elif kind == "p":
                add_paragraph(doc, payload)
            elif kind == "bullet":
                add_bullet(doc, payload)
            elif kind == "note":
                add_note(doc, payload)
            elif kind == "caption":
                add_caption(doc, payload)
            elif kind == "code":
                add_code(doc, payload)
            elif kind == "table":
                add_table(doc, payload)
            elif kind == "image":
                add_image(doc, payload[0], payload[1])
            elif kind == "pagebreak":
                doc.add_page_break()
            elif kind == "toc":
                p = doc.add_paragraph()
                add_field(p, 'TOC \\o "1-3" \\h \\z \\u',
                          "Mục lục: bấm chuột phải → Update Field (hoặc Ctrl+A, F9) để cập nhật số trang.")
            first_block = False

    OUT_DOCX.parent.mkdir(parents=True, exist_ok=True)
    doc.save(OUT_DOCX)
    print(f"Đã xuất: {OUT_DOCX}")
    print(f"  nguồn: {len(sources)} tệp .md")
    print(f"  số đoạn: {len(doc.paragraphs)}, số bảng: {len(doc.tables)}")


if __name__ == "__main__":
    build()
