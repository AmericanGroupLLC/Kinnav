// Hidden decoy field. Humans never see it, so anything that fills it in is a
// bot — the server silently drops those submissions. Kept off-screen rather
// than display:none, which some bots specifically skip.
export default function Honeypot({ value, onChange }) {
  return (
    <div style={{ position: 'absolute', left: '-9999px', top: 0, width: 1, height: 1, overflow: 'hidden' }} aria-hidden="true">
      <label htmlFor="website">Leave this field empty</label>
      <input
        id="website"
        name="website"
        type="text"
        tabIndex={-1}
        autoComplete="off"
        value={value}
        onChange={e => onChange(e.target.value)}
      />
    </div>
  )
}
